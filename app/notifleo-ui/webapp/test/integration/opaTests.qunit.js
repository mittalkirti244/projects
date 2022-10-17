sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'notifleoui/test/integration/FirstJourney',
		'notifleoui/test/integration/pages/WorkItemsList',
		'notifleoui/test/integration/pages/WorkItemsObjectPage'
    ],
    function(JourneyRunner, opaJourney, WorkItemsList, WorkItemsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('notifleoui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheWorkItemsList: WorkItemsList,
					onTheWorkItemsObjectPage: WorkItemsObjectPage
                }
            },
            opaJourney.run
        );
    }
);