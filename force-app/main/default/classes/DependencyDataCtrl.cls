public with sharing class DependencyDataCtrl {

	public List<GexfAttribute> attributes { get; private set; }
	public List<GexfNode> nodes { get; private set; }
	public List<GexfEdge> edges { get; private set; }


	// CONSTRUCTOR

	public DependencyDataCtrl() {
		fetchDependencies();
		fetchNodeAttributes();
	}


	// PRIVATE

	private void fetchDependencies() {

	}


	private void fetchNodeAttributes() {

	}

	// INNER

	public class GexfAttribute {
		public String id { get; private set; }
		public String title { get; private set; }
		public String type { get; private set; }
		public String defaultValue { get; private set; }
	}

	public class GexfNode {
		public String id {get; set;}
		public String label { get; private set; }
		public Map<String, String> attributes { get; private set; }
	}

	public class GexfEdge {
		public String id { get; private set; }
		public String source { get; private set; }
		public String target { get; private set; }
	}
}