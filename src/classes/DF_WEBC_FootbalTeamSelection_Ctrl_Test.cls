@isTest
private class DF_WEBC_FootbalTeamSelection_Ctrl_Test
{
	@isTest
	static void itShould()
	{

		DF_WEBC_FootballTeamSelection_Controller ctl = new DF_WEBC_FootballTeamSelection_Controller();
		List<SelectOption> options = ctl.getFootballTeams();

	}
}