public with sharing class OrgDependenciesCtrl {

    @RemoteAction
    public static String graphXml() {
        return Page.graphData.getContent().toString();
    }
}