sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'notifleoui/test/integration/FirstJourney',
		'notifleoui/test/integration/pages/MaintenanceRequestHeaderList',
		'notifleoui/test/integration/pages/MaintenanceRequestHeaderObjectPage'
    ],
    function(JourneyRunner, opaJourney, MaintenanceRequestHeaderList, MaintenanceRequestHeaderObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('notifleoui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheMaintenanceRequestHeaderList: MaintenanceRequestHeaderList,
					onTheMaintenanceRequestHeaderObjectPage: MaintenanceRequestHeaderObjectPage
                }
            },
            opaJourney.run
        );
    }
);