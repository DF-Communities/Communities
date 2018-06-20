public without sharing class DF_WEBC_CreateActions extends DF_WEBC_ControllerBase {

 public Boolean isChampion {
  get;
  set;
 }
 public final String ID_PARAM = 'Id';
 public Boolean publicCheckbox {
  get;
  set;
 }
 public String oldAction;
 public Action__c act {
  get;
  set;
 }
 public String action5 {
  get;
  set;
 }
 List < Action__c > lisAct {
  get;
  set;
 }
 List < Action__c > lisActDelete {
  get;
  set;
 }
 List < Action__c > lisActUpsert {
  get;
  set;
 }
 Map < String, Action__c > actionMap;
 Map < String, String > selectedActions;
 public List < string > Actionname {
  get;
  set;
 }
 public string pOption1 = 'Get in touch with someone with dementia';
 public string pOption2 = 'Volunteer for an org that helps PWD';
 public string pOption3 = 'Campaign for change';
 public string pOption4 = 'Wear my badge and tell five friends';
 public string pOption5 = 'Carry out own action';
 public string pValue1 = 'Get in touch and stay in touch with someone I know living with dementia';
 public string pValue2 = 'Volunteer for an organisation that helps people with dementia';
 public string pValue3 = 'Campaign for change';
 public string pValue4 = 'Wear my badge and tell five friends about the Dementia Friends initiative';

 public List < string > standardActions = new List < string > {
  pOption1,
  pOption2,
  pOption3,
  pOption4,
  pOption5
 };
 public static final String DFACTION_RT = 'DF_Action';




 public PageReference cancel() {
  return new PageReference('/user-home');
 }

 public List < selectoption > getActionNames() {
  list < selectoption > options = new list < selectoption > ();
  try {

   Schema.DescribeFieldResult fieldResult = Action__c.Standard_Actions__c.getDescribe();

   list < schema.picklistentry > values = fieldResult.getPickListValues();
   for (Schema.PicklistEntry a: values) {
    if (a.getValue() == pOption1) {
     options.add(new SelectOption(a.getlabel(), pValue1));
    }
    if (a.getValue() == pOption2) {
     options.add(new SelectOption(a.getLabel(), pValue2));
    }
    if (a.getValue() == pOption3) {
     options.add(new SelectOption(a.getLabel(), pValue3));
    }
    if (a.getValue() == pOption4) {
     options.add(new SelectOption(a.getLabel(), pValue4));
    }

   }
  } catch (Exception e) {
   ApexPages.addMessages(e);
  }
  system.debug('## Product Name Options' + options);
  return options;
 }



 public PageReference saveactions() {

System.debug('Started saveactions');
// Update the user to converted status
if(currentdfc.Status__c != 'Converted') {
    DF_Contact__c newC = new DF_Contact__c(Id = currentdfc.Id,
                                           Status__c = 'Converted',
                                           Session_Code_Verified__c = true);
    update newC ;
}
  
  
  lisActUpsert = new List < Action__c > ();
  lisActDelete = new List < Action__c > ();
  selectedActions = new Map < String, String > ();
  system.debug('captured check box' + actionname);
  system.debug('ACTION MAP' + actionMap);
  system.debug('friendActRT RECORDTYPE ' + DF_Utils.getActionRecordTypeId(DFACTION_RT));
  PageReference pr = new PageReference('/user-home');
  pr.setRedirect(true);
  for (string s: actionname) {
   selectedActions.put(s, s);

   if (actionMap.get(s) == null) {

    //insert standard actions
    act = new Action__c(DF_Contact__c = currentdfc.id, Standard_Actions__c = s, Public__c = false, RecordTypeId = DF_Utils.getActionRecordTypeId(DFACTION_RT));
    lisActUpsert.add(act);

   }
  

  }

  for (Action__c a: lisAct) {
   //delete actions other than personal action
   if (selectedActions.get(a.Standard_Actions__c) == null && a.Standard_Actions__c != pOption5) {

    lisActDelete.add(a);


   }
   //delete personal action
   if (a.action__c != null && action5 == '') {

    lisActDelete.add(a);
   }
   //update personal action
   if (a.action__c != null && (action5 != a.action__c || a.Public__c != publicCheckbox) && action5.length() > 0) {
    a.Action__c = action5;
    a.Public__c = publicCheckbox;
    update a;

    pr.getParameters().put('action_updated', 'true');
    return pr;

   }

  }
  //insert personal action 
  if (action5.length() > 0 && actionMap.get(pOption5) == null) {
   system.debug('update pOption5');
   act = new Action__c(DF_Contact__c = currentdfc.id, Standard_Actions__c = pOption5, Action__c = action5, Public__c = publicCheckbox, RecordTypeId = DF_Utils.getActionRecordTypeId(DFACTION_RT));
   lisActUpsert.add(act);

  }



  if (lisActUpsert.size() > 0) {
   insert lisActUpsert;
   //google tracking QP-5
   pr.getParameters().put('action_created', 'true');
   return pr;
  }

  delete lisActDelete;
  
  

  return pr;
 }

 public DF_WEBC_CreateActions() {

  system.debug('ACTION 5 ' + ACTION5);
  Actionname = new List < String > ();
  isChampion = DF_Utils.isChampion(currentDfc);
  system.debug('ID RETURN' + ApexPages.currentPage().getParameters().get(ID_PARAM));


  // if (currentdfc != null){    
  lisAct = [select Public__c, Standard_Actions__c, DF_Contact__c, Action__c from Action__c where DF_Contact__c = : currentDfc.id LIMIT 5];
  actionMap = new Map < String, Action__c > ();

  for (Action__c a: lisAct) {
   actionMap.put(a.Standard_Actions__c, a);

   for (String s: standardActions) {

    if (a.Standard_Actions__c == s && a.Action__c == null) {

     Actionname.add(s);
     SYSTEM.DEBUG('STANDARD ACTION' + Actionname);
    }

    if (a.Standard_Actions__c == s && a.Action__c != null) {

     Actionname.add(s);
     action5 = a.Action__c;
     a.Standard_Actions__c = pOption5;
     oldAction = a.Action__c;
     publicCheckbox = a.Public__c;
    }

   }
  }
  //}
 }

}