package jobs.steps

import org.transmartproject.core.dataquery.DataRow
import org.transmartproject.core.dataquery.highdim.AssayColumn

import static jobs.AbstractAnalysisJob.SHORT_NAME

class ValueGroupDumpDataStep extends AbstractDumpHighDimensionalDataStep {

    @Override
    protected computeCsvRow(String subsetName,
                            DataRow row,
                            Long rowNumber,
                            AssayColumn column,
                            Object cell) {
        [
                "${SHORT_NAME[subsetName]}_${column.patientInTrialId}",
                row[column],
                row.label
        ]
    }

    final List<String> csvHeader = [ 'PATIENT_NUM', 'VALUE', 'GROUP' ]
}
