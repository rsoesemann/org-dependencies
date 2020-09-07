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