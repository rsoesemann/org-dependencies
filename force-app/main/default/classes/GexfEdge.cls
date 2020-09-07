public class GexfEdge {

	public String id { get; private set; }
	public String source { get; private set; }
	public String target { get; private set; }

	public GexfEdge(String source, String target) {
		this.source = source;
		this.target = target;
	}
}