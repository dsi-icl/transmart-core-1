--
-- Name: i2b2; Type: TABLE; Schema: i2b2metadata; Owner: -
--
CREATE TABLE i2b2 (
    c_hlevel numeric(22,0) NOT NULL,
    c_fullname character varying(700) NOT NULL,
    c_name character varying(2000) NOT NULL,
    c_synonym_cd character(1) NOT NULL,
    c_visualattributes character(3) NOT NULL,
    c_totalnum numeric(22,0),
    c_basecode character varying(50),
    c_metadataxml text,
    c_facttablecolumn character varying(50) NOT NULL,
    c_tablename character varying(150) NOT NULL,
    c_columnname character varying(50) NOT NULL,
    c_columndatatype character varying(50) NOT NULL,
    c_operator character varying(10) NOT NULL,
    c_dimcode character varying(700) NOT NULL,
    c_comment text,
    c_tooltip character varying(900),
    m_applied_path character varying(700) NOT NULL,
    update_date timestamp without time zone NOT NULL,
    download_date timestamp without time zone,
    import_date timestamp without time zone,
    sourcesystem_cd character varying(50),
    valuetype_cd character varying(50),
    m_exclusion_cd character varying(25),
    c_path character varying(700),
    c_symbol character varying(50),
    i2b2_id bigint
);

--
-- Name: i2b2_c_comment_char_length_idx; Type: INDEX; Schema: i2b2metadata; Owner: -
--
CREATE INDEX i2b2_c_comment_char_length_idx ON i2b2 USING btree (c_comment, char_length((c_fullname)::text));

--
-- Name: idx_i2b2_fullname_basecode; Type: INDEX; Schema: i2b2metadata; Owner: -
--
CREATE INDEX idx_i2b2_fullname_basecode ON i2b2 USING btree (c_fullname, c_basecode);

--
-- Name: ix_i2b2_source_system_cd; Type: INDEX; Schema: i2b2metadata; Owner: -
--
CREATE INDEX ix_i2b2_source_system_cd ON i2b2 USING btree (sourcesystem_cd);

--
-- Name: tf_trg_i2b2_id(); Type: FUNCTION; Schema: i2b2metadata; Owner: -
--
CREATE FUNCTION tf_trg_i2b2_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
       if NEW.I2B2_ID is null then
 select nextval('i2b2metadata.I2B2_ID_SEQ') into NEW.I2B2_ID ;
end if;
       RETURN NEW;
end;
$$;

--
-- Name: trg_i2b2_id; Type: TRIGGER; Schema: i2b2metadata; Owner: -
--
CREATE TRIGGER trg_i2b2_id BEFORE INSERT ON i2b2 FOR EACH ROW EXECUTE PROCEDURE tf_trg_i2b2_id();

--
-- Name: i2b2_id_seq; Type: SEQUENCE; Schema: i2b2metadata; Owner: -
--
CREATE SEQUENCE i2b2_id_seq
    START WITH 496244
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- add documentation
--
COMMENT ON TABLE i2b2metadata.i2b2 IS 'Holds all nodes in the i2b2 tree.';

COMMENT ON COLUMN i2b2.c_hlevel IS 'Number that represents the depth of the node. 0 for root.';
COMMENT ON COLUMN i2b2.c_fullname IS 'Full path to the node. E.g., \Vital Signs\Heart Rate\.';
COMMENT ON COLUMN i2b2.c_name IS 'Name of the node. E.g., Heart Rate.';
COMMENT ON COLUMN i2b2.c_basecode IS 'Code that represents node. E.g., VSIGN:HR. Not used.';
COMMENT ON COLUMN i2b2.c_visualattributes IS 'Visual attributes describing how a node should be displayed. Can have three characters at maximum. See OntologyTerm#VisualAttributes for documentation on the values.';
COMMENT ON COLUMN i2b2.c_metadataxml IS 'Metadata encoded as XML.';
COMMENT ON COLUMN i2b2.c_facttablecolumn IS 'Column of observation_fact corresponding with c_columnname.';
COMMENT ON COLUMN i2b2.c_tablename IS 'Table of the dimension referred to by this node.';
COMMENT ON COLUMN i2b2.c_columnname IS 'Column of the table of the dimension referred to by this node';
COMMENT ON COLUMN i2b2.c_operator IS 'Operator. E.g., like, =';
COMMENT ON COLUMN i2b2.c_dimcode IS 'Refers to a dimension element, linked to observations.';
COMMENT ON COLUMN i2b2.c_comment IS 'Meant for comments, not for storing study based security tokens.';
