public with sharing class DependencyExplorerCtrl {

	public List<GexfAttribute> attributes { get; private set; }
	public Map<String, GexfNode> nodes { get; private set; }
	public List<GexfEdge> edges { get; private set; }


	// CONSTRUCTOR

	public DependencyExplorerCtrl() {
		attributes = new List<GexfAttribute>{
			new GexfAttribute('type', 'String'),
			new GexfAttribute('sfdcId', 'String'),
			new GexfAttribute('name', 'String')

		};
		nodes = new Map<String, GexfNode>();
		edges = new List<GexfEdge>();


		for(MetadataComponentDependency dependency : queryOrgDependencies()) {
			register( dependency.gexfSource() );
			register( dependency.gexfTarget() );

			edges.add( dependency.gexfEdge() );
		}
	}


	// PRIVATE

	private List<MetadataComponentDependency> queryOrgDependencies() {
		String query = 'SELECT MetadataComponentId, MetadataComponentName, MetadataComponentType, RefMetadataComponentId, RefMetadataComponentName, RefMetadataComponentType FROM MetadataComponentDependency';
		return (List<MetadataComponentDependency>) queryToolingApi(query).records;
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


	private void register(GexfNode node) {
		if( !nodes.containsKey(node.label)) {
			nodes.put(node.id, node);
		}
	}


	// INNER

	public class ToolingApiResponse {
		List<Object> records;
	}


	public class MetadataComponentDependency {
		public String MetadataComponentId;
		public String MetadataComponentName;
		public String MetadataComponentType;
		public String RefMetadataComponentId;
		public String RefMetadataComponentName;
		public String RefMetadataComponentType;

		public GexfNode gexfSource() {
			return new GexfNode(MetadataComponentType + '::' + MetadataComponentName)
					.attribute('type', MetadataComponentType)
					.attribute('name', MetadataComponentName)
					.attribute('sfdcId', MetadataComponentId);
		}

		public GexfNode gexfTarget() {
			return new GexfNode(RefMetadataComponentType + '::' + RefMetadataComponentName)
					.attribute('type', RefMetadataComponentType)
					.attribute('name', RefMetadataComponentName)
					.attribute('sfdcId', RefMetadataComponentId);
		}

		public GexfEdge gexfEdge() {
			return new GexfEdge(gexfSource().id, gexfTarget().id);
		}
	}

	public class GexfEdge {
		public String id { get; private set; }
		public String source { get; private set; }
		public String target { get; private set; }

		public GexfEdge(String source, String target) {
			this.source = source;
			this.target = target;
		}
	}


	public class GexfNode {
		public String id {get; private set;}
		public String label { get; private set; }
		public Map<String, String> attributes { get; private set; }

		public GexfNode(String id) {
			attributes = new Map<String, String>();
			this.id = id;
			this.label = id;
		}

		public GexfNode attribute(String key, String value) {
			attributes.put(key, value);
			return this;
		}
	}


	public class GexfAttribute {
		public String id { get; private set; }
		public String title { get; private set; }
		public String type { get; private set; }

		public GexfAttribute(String id, String type) {
			this.id = id;
			title = id;
			this.type = type;
		}
	}
}