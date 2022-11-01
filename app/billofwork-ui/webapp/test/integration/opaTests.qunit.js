sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'billofworkui/test/integration/FirstJourney',
		'billofworkui/test/integration/pages/BillOfWorksList',
		'billofworkui/test/integration/pages/BillOfWorksObjectPage'
    ],
    function(JourneyRunner, opaJourney, BillOfWorksList, BillOfWorksObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('billofworkui') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheBillOfWorksList: BillOfWorksList,
					onTheBillOfWorksObjectPage: BillOfWorksObjectPage
                }
            },
            opaJourney.run
        );
    }
);