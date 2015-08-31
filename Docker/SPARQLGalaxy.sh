python sparql.py /home/mikel/UPV-EHU/Eclipse_Workspace/SADI-Galaxy/use_cases/possible_use_case/Galaxy32-[Merge_RDF_Graphs_on_data_28,_data_12,_and_others].rdf "PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> PREFIX sio_resource: <http://semanticscience.org/resource/> SELECT ?protein ?label ?SNP WHERE { ?protein rdf:type <http://openlifedata.org/uniprot_vocabulary:Resource> . ?protein sio_resource:SIO_000272 ?SNP . ?protein ?prot2hgnc ?hgnc . ?hgnc ?hgnc2omim ?omim . ?omim ?omim2pubmed ?pubmed . ?pubmed rdfs:label ?label}" tab

PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> PREFIX sio_resource: <http://semanticscience.org/resource/> SELECT DISTINCT ?protein ?label ?SNP WHERE { ?protein rdf:type <http://openlifedata.org/uniprot_vocabulary:Resource> . ?protein sio_resource:SIO_000272 ?SNP . ?protein ?prot2hgnc ?hgnc . ?hgnc ?hgnc2omim ?omim . ?omim ?omim2pubmed ?pubmed . ?pubmed rdfs:label ?label . FILTER (regex (?label, "brain")) }