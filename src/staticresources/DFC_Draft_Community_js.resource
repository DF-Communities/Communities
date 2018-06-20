var app = angular.module('draftApp', []);



app.controller('draftCtrl', function($scope,actionService,$interval,$window,$location) {
 
   $scope.step ='step1'; 
   $scope.errortext=null;
   $scope.noActionAreas;


   
 //runs on init 
    actionService.invokeAction(DFC_RegisterCommunityController.dfcDraftContext, _webc.getFieldValue('communityId'))
        .then(function(data){
          console.log(data.alliances[0]);

          $scope.alliances= data.alliances;
          $scope.regions= data.regions;
          $scope.counties= data.counties;
          $scope.community = data.community;
          
          $scope.selectedRegion = data.community.Region__r;
          $scope.selectedDaa = data.community.DA_Alliance__r;
          $scope.community.County__c = data.community.County__c==null?'Select County':data.community.County__c;
          $scope.daa = $scope.alliances;
          $scope.locationType = ['Rural' ,'Village' ,'Town' ,'City' ,'Mixed'];
          $scope.locTypeSelected = {loctype:$scope.community.Location_Type__c};
          $scope.currentContact=data.currentContact.Id;
         
          if($scope.community!=null){

            if($scope.community.Status__c=='Draft' &&($scope.community.Country__c!='' || $scope.community.Country__c!=null))
              console.log('validate steps');
              initValidation('step1');
              initValidation('step2');
              initValidation('step4');
              initValidation('step3');
          }
          if($scope.community.Status__c=='New'){
             $scope.step1badge=null;
             $scope.step2badge =null;
            $scope.step3badge=null;
            $scope.step4badge=null;
          }


           
        })

        .catch(function(e){
                console.error(e);
                
      });



  
    $scope.updateActionDesc =function(update) {
      if(update==false){
        $scope.community.Action_Areas__r.Description__c='';
      
      }
    };


    $scope.isActionSelected =function() {
    if($scope.community==null){return;}
     var selected =false;
     for(var i=0;i<$scope.community.Action_Areas__r.length;i++){
     console.log($scope.community.Action_Areas__r[i].Selected__c);
      if($scope.community.Action_Areas__r[i].Selected__c){
              
              selected = true;
              
       }
       
      
    }
    return selected;
   };   

    var isActionDescNull =function() {
   // if($scope.community==null){return;}
    var errors=0;
     for(var i=0;i<$scope.community.Action_Areas__r.length;i++){
      
      if($scope.community.Action_Areas__r[i].Selected__c)
        
        if($scope.community.Action_Areas__r[i].Description__c==undefined){
            
              errors=errors+1;
              console.log('errors'+errors);
       }
       
      
      }
    return errors;
   };           
        

    $scope.changeCountry= function() {
      $scope.community.Country__c= ($scope.community.Country__c=='England'?'Wales':'England');
      $scope.regions.Country=$scope.community.Country__c;
      $scope.community.Status__c=($scope.community.Country__c!=null ?'Draft':'New');
      clearSelectedValues();

    };

    $scope.changeLocation= function() {
       $scope.community.Central_Location__c=($scope.community.Central_Location__c=='Yes'?'No':'Yes')
       if($scope.community.Central_Location__c=='Yes'){
        $scope.community.Why_No_Central_Location__c=null;

       }
       
       clearSelectedValues();
      // setUpdatedValues();

    };
  

    function clearSelectedValues() {
       
       $scope.selectedRegion = null;
       $scope.selectedDaa = null;
       $scope.communitiesForDaa=null;
       $scope.community.County__c = 'Select County';
       $scope.locTypeSelected = {loctype:''};
       $scope.community.Location_Type__c = '';
       $scope.community.Location__c = null;

    }

    $scope.changeRegion= function() {
       clearSelectedValues();
     //  setUpdatedValues();
    };

    $scope.changeDaa= function() {
       $scope.selectedDaa = null;
       $scope.communitiesForDaa=null;
      // setUpdatedValues();

    };
    $scope.regionSelected= function(regionId) {
   
     console.log(regionId);
        for(var i = 0 ; i < $scope.regions.length ; i++){
          if(regionId == $scope.regions[i].Id){
            $scope.selectedRegion=$scope.regions[i];
            break;
          }
        }
       
    };

    $scope.daaSelected= function(daaId) {
      
       for(var i = 0 ; i < $scope.alliances.length ; i++){
          if(daaId == $scope.alliances[i].Id){
            $scope.selectedDaa=$scope.alliances[i];
           // setUpdatedValues();
            break;
          }
        }
       actionService.invokeAction(DFC_RegisterCommunityController.getCommunitiesForDaa, daaId)
      .then(function(data){
        console.log('duplicate'+data);
        if(data==null || data==''){
          $scope.community.Duplicate_Confirmation__c=true;
        }
        $scope.communitiesForDaa = data;
        

      })
        .catch(function(e){
                console.error(e);
      });
      

    };


    $scope.dupeConfirm= function() {
      console.log($scope.community.Duplicate_Confirmation__c);
       $scope.community.Duplicate_Confirmation__c = true;
       $scope.communitiesForDaa=null;
     
    };

   
     $scope.countySelected= function(countyId) {
    
            $scope.community.County__c=countyId;
        
                  
    };


    var validateSteps = function(){
      console.log('validateSteps');
         $(".validation:visible").length;

        $scope.haserrors = ($scope.step1badge>0 || $scope.step2badge >0 || $scope.step3badge >0 ||$scope.step4badge>0?true:false);
        $scope.errorlist=[];
        
        var activeStep=$(".stepactive").attr('id');
         if(activeStep=='step1'){
        $scope.step1badge = $(".validation:visible").length;
        $scope.errorlist.push({step:'Community Location',index:1,errors:$scope.step1badge});
        $scope.errorlist.push({step:'Community Details',index:2,errors:$scope.step2badge});
        $scope.errorlist.push({step:'Community Representatives',index:3,errors:$scope.step3badge});
        $scope.errorlist.push({step:'Community Areas For Action',index:4,errors:$scope.step4badge});
        $scope.haserrors = ($scope.step1badge>0 || $scope.step2badge >0 || $scope.step3badge >0 ||$scope.step4badge>0?true:false);
        }
         if(activeStep=='step2'){
        $scope.step2badge = $(".validation:visible").length;
        $scope.errorlist.push({step:'Community Location',index:1,errors:$scope.step1badge});
        $scope.errorlist.push({step:'Community Details',index:2,errors:$scope.step2badge});
        $scope.errorlist.push({step:'Community Representatives',index:3,errors:$scope.step3badge});
        $scope.errorlist.push({step:'Community Areas For Action',index:4,errors:$scope.step4badge});
        $scope.haserrors = ($scope.step1badge>0 || $scope.step2badge >0 || $scope.step3badge >0 ||$scope.step4badge>0?true:false);

        }
         if(activeStep=='step3'){

        $scope.step3badge = $(".validation:visible").length;
        $scope.errorlist.push({step:'Community Location',index:1,errors:$scope.step1badge});
        $scope.errorlist.push({step:'Community Details',index:2,errors:$scope.step2badge});
        $scope.errorlist.push({step:'Community Representatives',index:3,errors:$scope.step3badge});
        $scope.errorlist.push({step:'Community Areas For Action',index:4,errors:$scope.step4badge});
        $scope.haserrors = ($scope.step1badge>0 || $scope.step2badge >0 || $scope.step3badge >0 ||$scope.step4badge>0?true:false);
        }
         if(activeStep=='step4'){
         
        $scope.step4badge = $(".validation:visible").length;
        $scope.errorlist.push({step:'Community Location',index:1,errors:$scope.step1badge});
        $scope.errorlist.push({step:'Community Details',index:2,errors:$scope.step2badge});
        $scope.errorlist.push({step:'Community Representatives',index:3,errors:$scope.step3badge});
        $scope.errorlist.push({step:'Community Areas For Action',index:4,errors:$scope.step4badge});
        $scope.errorlist.push({step:'Community Areas For Action',index:4,errors:$scope.step4badge==0&&$scope.step3badge==0&&$scope.isActionSelected()==false?1:0});
        $scope.haserrors = ($scope.step1badge>0 || $scope.step2badge >0 || $scope.step3badge >0 ||$scope.step4badge>0?true:false);

        }
        if(activeStep=='step5'){
          
        $scope.step5badge = $(".validation:visible").length;

        $scope.errorlist.push({step:'Community Location',index:1,errors:$scope.step1badge});
        $scope.errorlist.push({step:'Community Details',index:2,errors:$scope.step2badge});
        $scope.errorlist.push({step:'Community Representatives',index:3,errors:$scope.step3badge});
        $scope.errorlist.push({step:'Community Areas For Action',index:4,errors:$scope.step4badge});
        
        $scope.haserrors = ($scope.step1badge>0 || $scope.step2badge >0 || $scope.step3badge >0 || $scope.step4badge>0?true:false);
        }

        if(activeStep=='step6'){
        $scope.step6badge = $(".validation:visible").length;

        $scope.errorlist.push({step:'Community Location',index:1,errors:$scope.step1badge});
        $scope.errorlist.push({step:'Community Details',index:2,errors:$scope.step2badge});
        $scope.errorlist.push({step:'Community Representatives',index:3,errors:$scope.step3badge});
        $scope.errorlist.push({step:'Community Areas For Action',index:4,errors:$scope.step4badge});
        $scope.haserrors = ($scope.step1badge>0 || $scope.step2badge >0 || $scope.step3badge >0 ||$scope.step4badge>0?true:false);

        }

    };
      $scope.initVal = function(step) {
           initValidation(step);
      };
      var initValidation= function(step) {
           
           var step1fields=[$scope.community.Country__c==null?1:0,
                            $scope.community.Country__c!=null &&$scope.community.Central_Location__c==null?1:0,
                            $scope.community.Central_Location__c=='No'&& $scope.community.Why_No_Central_Location__c==null?1:0,
                            $scope.community.Central_Location__c=='Yes'&& $scope.selectedRegion==null?1:0,
                            $scope.selectedDaa!=null && $scope.community.Duplicate_Confirmation__c==false?1:0
                            ];
           var step2fields=[$scope.community.Name__c==null ?1:0,
                            $scope.community.Central_Location__c=='Yes'&& ($scope.community.County__c==null || $scope.community.County__c=='Select County')?1:0,
                            $scope.community.Population__c==null?1:0,
                            $scope.community.Central_Location__c=='Yes'&&$scope.community.Location__c==null?1:0,
                            $scope.community.Central_Location__c=='Yes'&&$scope.locTypeSelected.loctype==undefined?1:0];
           var step4fields=[$scope.isActionSelected()==false?1:0];
           
            



          if(step=='step2'){
               $scope.step2badge=0;

           console.log(step2fields);
             angular.forEach(step2fields,function(value,index){
                           
                   if(value=='1'){
                    $scope.step2badge=$scope.step2badge+value;
                  
                  }
          
            
           })
             
         

          }
            if(step=='step1'){
                 $scope.step1badge=0;
       
                console.log(step1fields);
              angular.forEach(step1fields,function(value,index){
                           
                   if(value=='1'){
                    $scope.step1badge=$scope.step1badge+value;
                  
                  }
          
            
           })
             
         

          }

           if(step=='step4'){
            
            console.log(isActionDescNull());
               $scope.step4badge=0;   
            angular.forEach(step4fields,function(value,index){   
            if(value=='1'){
              console.log('step4'+step4fields);
                    $scope.step4badge=$scope.step4badge+value;

                    console.log('step5'+angular.toJson($scope.errorlist));
                   
                  }
            })
            
             if(isActionDescNull()>0){
               
               $scope.step4badge=isActionDescNull();

             }
            
            
           }

           if(step=='step3'){

               $scope.step3badge=0;
                  
          }

          

    };

   

   $scope.updateCommunity = function(step){
       
        if(step=='step5') {
          $scope.community.Status__c = 'Requested';
        }
        $scope.step=step;
       
        validateSteps();
        
        var comm = {};
      
        comm.country = $scope.community.Country__c;
        comm.centralLocation = $scope.community.Central_Location__c;
        comm.noLocation = $scope.community.Why_No_Central_Location__c;
        comm.region = $scope.selectedRegion==null?null:$scope.selectedRegion.Id;
        comm.Daa =$scope.selectedDaa==null?null:$scope.selectedDaa.Id;
        comm.Duplicate = $scope.community.Duplicate_Confirmation__c;
        comm.name = $scope.community.Name__c;
        comm.county = $scope.community.County__c=='Select County'?null:$scope.community.County__c;
        comm.location = $scope.community.Location__c;
        comm.population = $scope.community.Population__c;
        comm.ltype =$scope.locTypeSelected.loctype;
        comm.actionAreas =angular.copy($scope.community.Action_Areas__r);
        comm.status = $scope.community.Status__c=='New' && $scope.community.Country__c!=null ? 'Draft' : $scope.community.Status__c;
        comm.datesubmitted=$scope.community.Date_Submitted__c!=null?new Date($scope.community.Date_Submitted__c).toUTCString():null;
        
        actionService.invokeAction(DFC_RegisterCommunityController.saveCommunity, comm ,_webc.getFieldValue('communityId'))
        .then(function(data){
   
         $scope.errortext =null; 
         
        })
        .catch(function(e){
                console.error(e);
                if(e.includes('DUPLICATE_VALUE')){
                $scope.errortext = 'There is already a community with the name: ' + $scope.community.Name__c;
                }
      });            
  };
    


  $scope.requestCommunity = function(){
    $scope.community.Status__c = 'Requested';
    $scope.community.Date_Submitted__c =new Date().toUTCString();
    return $scope.updateCommunity('step5');
 }

 $scope.submitApplication= function(){
     $scope.requestCommunity();
     $window.location.href ='/DFC_application_submitted?dfcid='+$scope.community.Id;
        
 };


   $scope.countOf = function(text) {
    var s = text ? text.split(/\s+/) : 0; // it splits the text on space/tab/enter
    var sReturn = s.length==1? s.length +' '+ 'word':s.length +' '+ 'words'
    return sReturn;
};  

   
     actionService.invokeAction(DFC_RegisterCommunityController.existingReps, _webc.getFieldValue('communityId'))
        .then(function(data){
          console.log('existing reps'+data.Reps);
          $scope.reps=data;
          
          
        })
        .catch(function(e){
                console.error(e);

    
   });
   
    var loadNewReps = function (rep,role){
  
      if(role=='Invited'){
        $scope.reps.push({Id:rep.Id,Name:rep.Invited_Name__c,
          Email:rep.Invited_Email__c
          ,Role:rep.Role__c});
          $scope.isInvite=false; 
        }
       if (role=='Registered') {
           $scope.reps.push({Id:rep.Id,Name:rep.DF_Contact__r.Name,
          Email:rep.DF_Contact__r.Email__c
          ,Role:rep.Role__c});
        }
        $("#emailAddress").val('');
        $scope.$apply();
    };

    $scope.handleDelete= function (repid) {
       
      actionService.invokeAction(DFC_RegisterCommunityController.deleteRepresentative, _webc.getFieldValue('communityId'),repid)
        .then(function(data){
                   
              $scope.repRemoved=true;
              $scope.newRepText='';
        })
        .catch(function(e){
                console.error(e);
    
       });

   };

   $scope.handleInvites = function () {
      $scope.invitenameerror=false;
         console.log('Invite button been clicked');
         if($scope.invitename==null || $scope.invitename==''){
          $scope.invitenameerror=true;
          return;
         }
    else{
      actionService.invokeAction(DFC_RegisterCommunityController.inviteRepresentative, _webc.getFieldValue('communityId'),_webc.getFieldValue('emailAddress'),_webc.getFieldValue('nameinput'))
        .then(function(data){

           loadNewReps(data,'Invited');       
          
        })
        .catch(function(e){
                console.error(e);
    
      });
    }
   }




   $scope.handleReps=function() {
       $scope.newRepText='';
       $scope.invitename=='';
       $scope.isInvite =false;

     
    
    console.log('Add button been clicked');
      actionService.invokeAction(DFC_RegisterCommunityController.handleReps,_webc.getFieldValue('communityId'), _webc.getFieldValue('emailAddress'))
                .then(function(data) {

          console.log(data);   
         if(data=='invite'){
          $scope.isInvite =true;
           
          }


         if(data!='invite' && data.DF_Contact__r==null){
           $scope.newRepText = data;
         }
        loadNewReps(data,'Registered'); 
          
          
    });
    
} 



     $scope.handleCancel=function() {
      
      $scope.isInvite =false;
      $scope.isAdd = false;
      $scope.inviteemail = null;
      $scope.invitename = null;
      $scope.invitenameerror = false;
    } 
   
    $scope.selectedStep= function(step){

           $scope.step = step;
    };

});


