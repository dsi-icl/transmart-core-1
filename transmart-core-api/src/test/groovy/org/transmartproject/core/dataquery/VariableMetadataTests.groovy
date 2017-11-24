/*
 * Copyright © 2013-2014 The Hyve B.V.
 *
 * This file is part of transmart-core-api.
 *
 * Transmart-core-api is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * transmart-core-api.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.transmartproject.core.dataquery

import org.junit.Test

import static org.hamcrest.MatcherAssert.assertThat
import static org.hamcrest.Matchers.*

class VariableMetadataTests {

    @Test
    void testBlankJsonString() {
        def jsonText = ''

        VariableMetadata metadata = VariableMetadata.fromJson(jsonText)
        assertThat metadata, nullValue()
    }

    @Test
    void testEmptyJson() {
        def jsonText = '{}'

        VariableMetadata metadata = VariableMetadata.fromJson(jsonText)
        assertThat metadata, allOf(
                hasProperty('type', nullValue()),
                hasProperty('measure', nullValue()),
                hasProperty('description', nullValue()),
                hasProperty('width', nullValue()),
                hasProperty('decimals', nullValue()),
                hasProperty('columns', nullValue()),
                hasProperty('valueLabels', equalTo([:])),
                hasProperty('missingValues', empty()),
        )
    }

    @Test
    void testAllFieldsParsing() {
        def jsonText = """
        {  
           "type":"Numeric",
           "measure":"ordinal",
           "description":"this is description",
           "width":"15",
           "decimals":"3",
           "columns":"18",
           "valueLabels":{  
              "-1.0":"M",
              "1.0":"A",
              "2.0":"B"
           },
           "missingValues":[-1.0]
        }
        """

        VariableMetadata metadata = VariableMetadata.fromJson(jsonText)

        assertThat metadata, allOf(
                hasProperty('type', equalTo(VariableDataType.NUMERIC)),
                hasProperty('measure', equalTo(Measure.ORDINAL)),
                hasProperty('description', equalTo('this is description')),
                hasProperty('width', equalTo(15)),
                hasProperty('decimals', equalTo(3)),
                hasProperty('columns', equalTo(18)),
                hasProperty('valueLabels', equalTo([(-1): 'M', 1: 'A', 2: 'B'])),
                hasProperty('missingValues', equalTo([-1])),
        )
    }

    @Test
    void testQuotedMissingValues() {
        def jsonText = """
        {  
           "missingValues":["-2.0"]
        }
        """

        VariableMetadata metadata = VariableMetadata.fromJson(jsonText)
        assertThat metadata, hasProperty('missingValues', equalTo([-2]))
    }

    @Test(expected = ArithmeticException)
    void testFloatMissingValues() {
        def jsonText = """
        {  
           "missingValues":["-3.14"]
        }
        """

        VariableMetadata.fromJson(jsonText)
    }

}
