public with sharing class OrgDependenciesCtrl {

    public DirectedGraph graph { get; private set; }


    // CONSTRUCTOR

    public OrgDependenciesCtrl() {
        graph = new DirectedGraph();

        graph.attributes.put('type', new Attribute('type') );

        for(MetadataComponentDependency dependency : queryOrgDependencies()) {
            graph.nodes.add( new Node(dependency.MetadataComponentId, dependency.MetadataComponentName)
                                    .attribute('type', dependency.MetadataComponentType) );
            graph.nodes.add( new Node(dependency.RefMetadataComponentId, dependency.RefMetadataComponentName)
                                    .attribute('type', dependency.MetadataComponentType) );

            graph.edges.add( new Edge(dependency.MetadataComponentId, dependency.RefMetadataComponentId) );
        }
    }


    // PRIVATE

    private List<MetadataComponentDependency> queryOrgDependencies() {
        String query = 'SELECT MetadataComponentId, MetadataComponentName, MetadataComponentType, RefMetadataComponentId, RefMetadataComponentName, RefMetadataComponentType FROM MetadataComponentDependency';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(URL.getOrgDomainUrl().toExternalForm()
                            + '/services/data/v49.0/tooling/query?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
        request.setMethod('GET');
        request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');

        ToolingApiResponse result = (ToolingApiResponse) JSON.deserialize(new Http().send(request).getBody(), ToolingApiResponse.class);
        return result.records;
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
    }


    public class DirectedGraph {
        public List<Edge> edges { get; private set; }
        public List<Node> nodes { get; private set; }
        public Map<String, Attribute> attributes { get; private set; }

        private DirectedGraph() {
            edges = new List<Edge>();
            nodes = new List<Node>();
            attributes = new Map<String, Attribute>();
        }
    }


    public class Edge {
        public String sourceId { get; private set; }
        public String targetId { get; private set; }

        public Edge(String source, String target) {
            sourceId = source;
            targetId = target;
        }
    }


    public class Node {
        public String id { get; private set; }
        public String label { get; private set; }
        public Map<String, Object> attributes { get; private set; }

        public Node(String id, String label) {
            this.id = id;
            this.label = label;
            attributes = new Map<String, Object>();
        }

        public Node attribute(String id, Object value) {
            attributes.put(id, value);
            return this;
        }
    }


    public class Attribute {
        public String id { get; private set; }
        public String label { get; private set; }
        public String type { get; private set; }

        public Attribute(String id) {
            this.id = id;
            label = id;
            type = 'String';
        }
    }
}