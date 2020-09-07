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