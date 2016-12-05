--
-- Name: linked_file_collection; Type: TABLE; Schema: i2b2demodata; Owner: -
--
CREATE TABLE linked_file_collection (
    id integer NOT NULL,
    name character varying(900),
    study character varying(50),
    source_system_id integer NOT NULL,
    uuid character varying(50)
);

--
-- Name: linked_file_collection_pkey; Type: CONSTRAINT; Schema: i2b2demodata; Owner: -
--
ALTER TABLE ONLY linked_file_collection
    ADD CONSTRAINT linked_file_collection_pkey PRIMARY KEY (id);

