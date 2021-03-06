package org.transmartproject.batch.highdim.rnaseq.transcript.data

import groovy.util.logging.Slf4j
import org.springframework.batch.core.Step
import org.springframework.batch.core.StepContribution
import org.springframework.batch.core.configuration.annotation.JobScope
import org.springframework.batch.core.configuration.annotation.StepScope
import org.springframework.batch.core.scope.context.ChunkContext
import org.springframework.batch.core.step.tasklet.Tasklet
import org.springframework.batch.core.step.tasklet.TaskletStep
import org.springframework.batch.item.ItemProcessor
import org.springframework.batch.item.ItemStreamReader
import org.springframework.batch.item.ItemWriter
import org.springframework.batch.item.file.transform.FieldSet
import org.springframework.batch.item.support.AbstractItemCountingItemStreamItemReader
import org.springframework.batch.repeat.RepeatStatus
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.ComponentScan
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Import
import org.transmartproject.batch.batchartifacts.CollectMinimumPositiveValueListener
import org.transmartproject.batch.batchartifacts.HeaderParsingLineCallbackHandler
import org.transmartproject.batch.batchartifacts.HeaderSavingLineCallbackHandler
import org.transmartproject.batch.batchartifacts.MultipleItemsLineItemReader
import org.transmartproject.batch.beans.JobScopeInterfaced
import org.transmartproject.batch.beans.StepBuildingConfigurationTrait
import org.transmartproject.batch.clinical.db.objects.Tables
import org.transmartproject.batch.db.DatabaseImplementationClassPicker
import org.transmartproject.batch.db.DbConfig
import org.transmartproject.batch.db.DeleteByColumnValueWriter
import org.transmartproject.batch.highdim.assays.AssayStepsConfig
import org.transmartproject.batch.highdim.assays.CurrentAssayIdsReader
import org.transmartproject.batch.highdim.datastd.*
import org.transmartproject.batch.highdim.jobparams.StandardHighDimDataParametersModule
import org.transmartproject.batch.highdim.rnaseq.data.RnaSeqDataMultipleVariablesPerSampleFieldSetMapper
import org.transmartproject.batch.highdim.rnaseq.data.RnaSeqDataValue
import org.transmartproject.batch.support.JobParameterFileResource

/**
 * Spring batch steps configuration for RNASeq transcript data upload
 */
@Configuration
@ComponentScan
@Import([DbConfig, AssayStepsConfig])
@Slf4j
class RnaSeqTranscriptDataStepsConfig implements StepBuildingConfigurationTrait {

    static int dataFilePassChunkSize = 10000

    @Autowired
    DatabaseImplementationClassPicker picker

    @Bean
    Step firstPass(ItemStreamReader rnaSeqDataTsvFileReader) {
        CollectMinimumPositiveValueListener minPosValueColector = collectMinimumPositiveValueListener()
        TaskletStep step = steps.get('firstPass')
                .chunk(dataFilePassChunkSize)
                .reader(rnaSeqDataTsvFileReader)
                .processor(compositeOf(
                new NegativeDataPointWarningProcessor(),
        ))
                .stream(minPosValueColector)
                .listener(minPosValueColector)
                .listener(logCountsStepListener())
                .build()

        wrapStepWithName('firstPass', step)
    }

    @Bean
    Step deleteHdData(CurrentAssayIdsReader currentAssayIdsReader) {
        steps.get('deleteHdData')
                .chunk(100)
                .reader(currentAssayIdsReader)
                .writer(deleteRnaSeqDataWriter())
                .build()
    }

    @Bean
    Step partitionDataTable() {
        Tasklet noImplementationTasklet = new Tasklet() {
            @Override
            RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
                log.info('Data table partition is not supported by this data type.')
            }
        }

        steps.get('partitionDataTable')
                .tasklet(noImplementationTasklet)
                .build()

    }

    @Bean
    Step secondPass(ItemWriter<RnaSeqDataValue> rnaSeqDataWriter,
                    ItemProcessor compositeOfRnaSeqSecondPassProcessors,
                    ItemStreamReader rnaSeqDataTsvFileReader) {
        TaskletStep step = steps.get('secondPass')
                .chunk(dataFilePassChunkSize)
                .reader(rnaSeqDataTsvFileReader)
                .processor(compositeOfRnaSeqSecondPassProcessors)
                .writer(rnaSeqDataWriter)
                .listener(logCountsStepListener())
                .listener(progressWriteListener())
                .build()

        step
    }

    @Bean
    @JobScopeInterfaced
    ItemProcessor<TripleStandardDataValue, TripleStandardDataValue> compositeOfRnaSeqSecondPassProcessors(
            @Value("#{jobParameters['ZERO_MEANS_NO_INFO']}") String zeroMeansNoInfo,
            @Value("#{jobParameters['SKIP_UNMAPPED_DATA']}") String skipUnmappedData) {
        def processors = []
        if (zeroMeansNoInfo == 'Y') {
            processors << new FilterZerosItemProcessor()
        }
        if (skipUnmappedData == 'Y') {
            processors << filterDataWithoutAssayMappingsItemProcessor()
        }
        processors << patientInjectionProcessor()
        processors << tripleStandardDataValueLogCalculationProcessor()

        compositeOf(*processors)
    }

    @Bean
    @JobScope
    CollectMinimumPositiveValueListener collectMinimumPositiveValueListener() {
        new CollectMinimumPositiveValueListener(minPositiveValueRequired: false)
    }

    @Bean
    @JobScope
    FilterDataWithoutAssayMappingsItemProcessor filterDataWithoutAssayMappingsItemProcessor() {
        new FilterDataWithoutAssayMappingsItemProcessor()
    }

    @Bean
    @JobScope
    PatientInjectionProcessor patientInjectionProcessor() {
        new PatientInjectionProcessor()
    }

    @Bean
    @JobScope
    TripleStandardDataValueLogCalculationProcessor tripleStandardDataValueLogCalculationProcessor() {
        new TripleStandardDataValueLogCalculationProcessor()
    }

    @Bean
    @JobScopeInterfaced
    org.springframework.core.io.Resource dataFileResource() {
        new JobParameterFileResource(
                parameter: StandardHighDimDataParametersModule.DATA_FILE)
    }

    @Bean
    @StepScope
    HeaderSavingLineCallbackHandler headerSavingLineCallbackHandler() {
        new HeaderSavingLineCallbackHandler()
    }

    @Bean
    @StepScope
    HeaderParsingLineCallbackHandler headerParsingLineCallbackHandler(
            RnaSeqDataMultipleVariablesPerSampleFieldSetMapper rnaSeqDataMultipleVariablesPerSampleFieldSetMapper) {
        new HeaderParsingLineCallbackHandler(
                registeredSuffixes: rnaSeqDataMultipleVariablesPerSampleFieldSetMapper.fieldSetters.keySet(),
                defaultSuffix: 'readcount'
        )
    }

    @Bean
    @StepScope
    AbstractItemCountingItemStreamItemReader<FieldSet> itemStreamReader(
            org.springframework.core.io.Resource dataFileResource,
            HeaderParsingLineCallbackHandler headerParsingLineCallbackHandler) {
        tsvFileReader(
                dataFileResource,
                linesToSkip: 1,
                columnNames: 'auto',
                saveHeader: headerParsingLineCallbackHandler,
                saveState: true
        )
    }

    @Bean
    @StepScope
    RnaSeqDataMultipleVariablesPerSampleFieldSetMapper rnaSeqDataMultipleVariablesPerSampleFieldSetMapper() {
        new RnaSeqDataMultipleVariablesPerSampleFieldSetMapper()
    }

    @Bean
    ItemStreamReader rnaSeqDataTsvFileReader(
            AbstractItemCountingItemStreamItemReader<FieldSet> itemStreamReader,
            RnaSeqDataMultipleVariablesPerSampleFieldSetMapper rnaSeqDataMultipleVariablesPerSampleFieldSetMapper) {
        new MultipleItemsLineItemReader(
                multipleItemsFieldSetMapper: rnaSeqDataMultipleVariablesPerSampleFieldSetMapper,
                itemStreamReader: itemStreamReader
        )
    }

    @Bean
    DeleteByColumnValueWriter<Long> deleteRnaSeqDataWriter() {
        new DeleteByColumnValueWriter<Long>(
                table: Tables.RNASEQ_TRANSCRIPT_DATA,
                column: 'assay_id')
    }

}
