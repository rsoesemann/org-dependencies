public with sharing class OrgDependenciesCtrl {

    public String rawData {
        get {
            return rawData();
        }
        private set;
    }

    @RemoteAction
    public static String rawData() {
        DirectedGraph result = new DirectedGraph()
                                        .add(new Attribute('type'));

        for(MetadataComponentDependency dependency : queryOrgDependencies()) {
            result
                .add( new Node(dependency.MetadataComponentId, dependency.MetadataComponentName)
                                .attribute('type', dependency.MetadataComponentType) )
                .add( new Node(dependency.RefMetadataComponentId, dependency.RefMetadataComponentName)
                                .attribute('type', dependency.MetadataComponentType) )

                .add( new Edge(dependency.MetadataComponentId, dependency.RefMetadataComponentId) );
        }

        return JSON.serialize(result);
    }


    // PRIVATE

    private static List<MetadataComponentDependency> queryOrgDependencies() {
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
        public List<Edge> edges = new List<Edge>();
        public List<Node> nodes = new List<Node>();
        public Map<String, Attribute> attributes = new Map<String, Attribute>();

        public DirectedGraph add(Attribute attribute) {
            attributes.put(attribute.id, attribute);
            return this;
        }

        public DirectedGraph add(Node node) {
            nodes.add(node);
            return this;
        }

        public DirectedGraph add(Edge edge) {
            edges.add(edge);
            return this;
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