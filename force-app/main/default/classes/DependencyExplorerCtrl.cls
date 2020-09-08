public with sharing class DependencyExplorerCtrl {

	public List<Gexf.Attribute> attributes { get; private set; }
	public Map<String, Gexf.Node> nodes { get; private set; }
	public List<Gexf.Edge> edges { get; private set; }


	// CONSTRUCTOR

	public DependencyExplorerCtrl() {
		attributes = new List<Gexf.Attribute>{
			new Gexf.Attribute('type', 'String'),
			new Gexf.Attribute('sfdcId', 'String'),
			new Gexf.Attribute('name', 'String')
		};
		nodes = new Map<String, Gexf.Node>();
		edges = new List<Gexf.Edge>();


		for(MetadataComponentDependency dependency : queryOrgDependencies()) {
			register( dependency.gexfSource() );
			register( dependency.gexfTarget() );

			edges.add( dependency.gexfEdge() );
		}
	}


	// PRIVATE

	private List<MetadataComponentDependency> queryOrgDependencies() {
		String query = 'SELECT MetadataComponentId, MetadataComponentName, MetadataComponentType, RefMetadataComponentId, RefMetadataComponentName, RefMetadataComponentType FROM MetadataComponentDependency';
		return queryToolingApi(query).records;
	}


	private ToolingApiResponse queryToolingApi(String query) {
		HttpRequest request = new HttpRequest();
		request.setEndpoint(URL.getOrgDomainUrl().toExternalForm()
				+ '/services/data/v49.0/tooling/query?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
		request.setMethod('GET');
		request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
		request.setHeader('Content-Type', 'application/json');

		return (ToolingApiResponse) JSON.deserialize(new Http().send(request).getBody(), ToolingApiResponse.class);
	}


	private void register(Gexf.Node node) {
		if( !nodes.containsKey(node.label)) {
			nodes.put(node.id, node);
		}
	}


	// INNER

	public class ToolingApiResponse {
		List<MetadataComponentDependency> records;
	}


	public class MetadataComponentDependency {
		public String MetadataComponentId;
		public String MetadataComponentName;
		public String MetadataComponentType;
		public String RefMetadataComponentId;
		public String RefMetadataComponentName;
		public String RefMetadataComponentType;

		public Gexf.Node gexfSource() {
			return new Gexf.Node(MetadataComponentType + '::' + MetadataComponentName)
					.attribute('type', MetadataComponentType)
					.attribute('name', MetadataComponentName)
					.attribute('sfdcId', MetadataComponentId);
		}

		public Gexf.Node gexfTarget() {
			return new Gexf.Node(RefMetadataComponentType + '::' + RefMetadataComponentName)
					.attribute('type', RefMetadataComponentType)
					.attribute('name', RefMetadataComponentName)
					.attribute('sfdcId', RefMetadataComponentId);
		}

		public Gexf.Edge gexfEdge() {
			return new Gexf.Edge(gexfSource().id, gexfTarget().id);
		}
	}


}