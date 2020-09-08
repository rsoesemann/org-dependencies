public class Gexf {
    
    public class Edge {
        public String id { get; private set; }
        public String source { get; private set; }
        public String target { get; private set; }

        public Edge(String source, String target) {
            this.source = source;
            this.target = target;
        }
    }


    public class Node {
        public String id {get; private set;}
        public String label { get; private set; }
        public Map<String, String> attributes { get; private set; }

        public Node(String id) {
            attributes = new Map<String, String>();
            this.id = id;
            this.label = id;
        }

        public Node attribute(String key, String value) {
            attributes.put(key, value);
            return this;
        }
    }


    public class Attribute {
        public String id { get; private set; }
        public String title { get; private set; }
        public String type { get; private set; }

        public Attribute(String id, String type) {
            this.id = id;
            title = id;
            this.type = type;
        }
    }
}