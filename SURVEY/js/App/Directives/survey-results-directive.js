app.directive('crudSurveyResults', function () {
    return {
        restrict: 'A',
        replace: false,
        scope: true,
        // put template View, cannot reuse same template for different object
        //templateUrl: '../js/App/Directives/Templates/crud-grid-directive-template.html',
        controller: ['$scope', '$window', '$element', '$attrs', 'crudGridDataFactory', 'notificationFactory', '$http', 'config', '$filter', '$q',
        function ($scope, $window, $element, $attrs, crudGridDataFactory, notificationFactory, $http, config, $filter, $q) {
            //---------------------------------------------------------------------------------- Declare Variable

            $scope.listSurveyResults = [];

            $scope.dllSurveyOnline = [];
            $scope.progressList = [];

            $scope.editingSurvey = {};
            $scope.searchParams = {};
            $scope.flagedit = 1; //1: List, 2: Detail
            $scope.flagSearchOne = false;
            $scope.flagLoadAllResults = false;
            $scope.flagLoadAllText = false;
            $scope.strState = {};
            $scope.strSurOnlId = '';

            $scope.reportSurveyResults = [];
            $scope.reportSurveyResultSummary = [];
            $scope.participations = [];

            $scope.summaryId = {};

            //----------------------------------------------------------------------------------Get List Base Survey
            $scope.getListBaseSurvey = function (pageIndex) {
                if ($attrs.summaryid != null && $attrs.summaryid == 0) {
                    //Run without search contact
                    var strquery = 'aa';

                    if ($scope.query['listSurveyResults'] != null) {
                        for (var q in $scope.query['listSurveyResults']) {
                            if (q == "DateCreated_From" || q == "DateCreated_To") {
                                var datestring = parseDateToString($scope.query['listSurveyResults'][q]);
                                if (datestring != '' && datestring != undefined) {
                                    strquery += '$' + q + '$' + datestring;
                                }
                            } else {
                                strquery += '$' + q + '$' + $scope.query['listSurveyResults'][q];
                            }
                        }
                    }

                    if (strquery.length > 0) strquery = strquery.substring(1);
                    strquery = encodeURIComponent(strquery);

                    $http.get(APP_ROOT + "api/" + $attrs.tableName + "/Get?langID=" + $attrs.langid + "&currentPage=" + pageIndex + "&itemsPerPage=" + $scope.pageSize + "&sortDirection=" + $scope.reverse['listSurveyResults'] + "&sortBy=" + $scope.sortingOrder['listSurveyResults'] + "&strwhere=" + strquery)
                        .success(function (data) {
                            $scope.totalSurveyResults = data.length > 0 ? data[0].TotalRow : 0;
                            $scope.surveyResultsCurrentPage = pageIndex;
                            $scope.listSurveyResults = data;
                        }).error(function (data) {
                            console.log('fail');
                        });
                } else {
                    //Run search with 1 contact - redirect to edit mode
                    $scope.summaryId = $attrs.summaryid;
                    $scope.flagedit = 2;
                    $("#sub-survey-results").css('display', 'none');
                    $scope.getContactSurvey();
                }

            };

            $scope.editSurvey = function (obj) {
                $scope.editingSurvey = obj;
                refreshWhenEdit();
                $scope.chkAllText();

                $scope.loadDdlSurveyOnline($scope.searchParams.DateFrom, $scope.searchParams.DateFrom, $scope.editingSurvey.Id);
                $scope.flagedit = 2;

                $scope.loadProgressState();

                setTimeout(function () {
                    // call uniform js to update element 
                    //$("select, input, a.button, button").uniform();

                    initUniform("input[type=text],input[type=checkbox], select, #reportServeyResults, #reportSurveyResultSummary, #dateChartSurvey, #exportExcelMatrix");
                    updateUniform("input[type=text],input[type=checkbox], select, #reportServeyResults, #reportSurveyResultSummary, #dateChartSurvey, #exportPDF, #exportExcel, #exportExcelMatrix");

                }, 1000);

            };

            $scope.openResultSummary = function (summaryId) {
                $window.open('../SurveyGeneral/SurverResultSummary?id=' + summaryId, '_blank');
            };

            function refreshWhenEdit() {
                $scope.searchParams = {};
                $scope.strState = {};
                $scope.strSurOnlId = {};
                $scope.reportSurveyResults = [];
                $scope.reportSurveyResultSummary = [];
                $scope.flagSearchOne = false;
                $scope.flagLoadAllText = false;
            }

            $scope.loadDdlSurveyOnline = function (dateFrom, dateTo, surveyId) {

                var strQuery = "";
                if (dateFrom != undefined && dateFrom != '')
                    strQuery += "dateFrom=" + parseDateToString(dateFrom);
                else
                    strQuery += "dateFrom=";

                if (dateTo != undefined && dateTo != '')
                    strQuery += "&dateTo=" + parseDateToString(dateTo);
                else
                    strQuery += "&dateTo=";

                if (surveyId != undefined && surveyId != '')
                    strQuery += "&surveyId=" + surveyId;
                else
                    strQuery += "&surveyId=";

                $http.get(APP_ROOT + "api/SurveyDdlSurveyOnline/Get?" + strQuery)
                        .success(function (data) {
                            $scope.dllSurveyOnline = data;
                        }).error(function (data) {
                            console.log('fail');
                        });
            };

            $scope.$watch('searchParams.DateFrom', function (newVal, oldVal) {
                if (newVal == oldVal) return;
                $scope.loadDdlSurveyOnline(newVal, $scope.searchParams.DateTo, $scope.editingSurvey.Id);
            });

            $scope.$watch('searchParams.DateTo', function (newVal, oldVal) {
                if (newVal == oldVal) return;
                $scope.loadDdlSurveyOnline($scope.searchParams.DateFrom, newVal, $scope.editingSurvey.Id);
            });

            $scope.loadProgressState = function () {
                $http.get(APP_ROOT + "SurveyGeneral/GetListProgressState?langId=" + $attrs.langid)
                       .success(function (data) {
                           $scope.progressList = data;
                       }).error(function (data) {
                           console.log('fail');
                       });
            };

            $scope.reportFlag = true;   //This field prevent angular call duplicate event
            $scope.reportSummaryFlag = true;   //This field prevent angular call duplicate event

            $scope.reportResults = function () {
                if (!$scope.reportFlag) return;
                $scope.reportFlag = false;
                
                var surveyOnline = "";
                var state = "";

                $scope.flagLoadAllResults = false;
                $scope.flagLoadAllText = false;
                $scope.chkAllText();

                //Check Survey has data SurveyOnline and show message
                if ($scope.dllSurveyOnline == '' || $scope.dllSurveyOnline == null) {
                    DisplayLoadPanel(ButtonText.Process);
                    DisplayErrorPanel(ValidText.HasNoSurveyOnline);
                    $scope.reportFlag = true;
                    return;
                }

                if ($scope.flagSearchOne) {
                    //Search 1 survey online
                    surveyOnline = $("#ddlSurveyOnline option:selected").val() + ",";
                } else {
                    //Search all survey online with date from / to
                    $("#ddlSurveyOnline option").each(function () {
                        if (typeof $(this).val() !== "undefined" && $(this).val() !== '0')
                            surveyOnline += $(this).val() + ",";
                    });
                }
                surveyOnline = surveyOnline.replace('? undefined:undefined ?,', '');
                $scope.strSurOnlId = surveyOnline;

                //Check has data and show message
                if (surveyOnline == '' || surveyOnline == undefined) {
                    DisplayLoadPanel(ButtonText.Process);
                    DisplayErrorPanel(ValidText.ChooseSurveyConfirm);
                    $scope.reportFlag = true;
                    return;
                }

                // Clean up previous result in the view
                $scope.reportSurveyResults = [];
                $scope.reportSurveyResultSummary = [];

                // Get state list
                $(".chkProgressState").each(function () {
                    if ($(this).attr('checked')) {
                        state += $(this).val() + ",";
                        $(this).attr('checked', 'checked');
                    } else {
                        $(this).removeAttr("checked");
                    }
                });
                $scope.strState = state;
                
                $(".overlay-loading, .modal-loading").show();
                // call ajax to get data
                $http.get(APP_ROOT + "api/SurveyReportResults/Report?surveyOnlineId=" + surveyOnline + "&progressStateId=" + state + "&langId=" + $attrs.langid + "&" + getDateFromToFilterParam())
                       .success(function (data) {
                           $scope.reportSurveyResults = data;
                         
                           $(".overlay-loading, .modal-loading").hide();
                           //initUniform("#exportPDF, #exportExcel, .btnTextButton");
                           //updateUniform("input[type=text],input[type=checkbox], select, #reportServeyResults, #reportSurveyResultSummary, #dateChartSurvey, #exportPDF, #exportExcel, #exportExcelMatrix"); //
                           initUniform("input[type=text],input[type=checkbox], #reportServeyResults, #reportSurveyResultSummary, #dateChartSurvey, #exportPDF, #exportExcel, #exportExcelMatrix, .btnTextButton");

                           setTimeout(CollapseAllReports, 300);

                           setTimeout(CalcParticipation(surveyOnline, state), 300);
                           $scope.reportFlag = true;
                       }).error(function (data) {
                           console.log('fail');
                           $scope.reportFlag = true;
                           $(".overlay-loading, .modal-loading").hide();
                       });
              
            };

            $scope.reportResultSummary = function () {
                if (!$scope.reportSummaryFlag) return;
                $scope.reportSummaryFlag = false;

                var surveyOnline = "";
                var state = "";

                $scope.flagLoadAllResults = false;
                $scope.flagLoadAllText = false;
                //$scope.chkAllText();

                //Check Survey has data SurveyOnline and show message
                if ($scope.dllSurveyOnline == '' || $scope.dllSurveyOnline == null) {
                    DisplayLoadPanel(ButtonText.Process);
                    DisplayErrorPanel(ValidText.HasNoSurveyOnline);
                    $scope.reportSummaryFlag = true;
                    return;
                }

                if ($scope.flagSearchOne) {
                    //Search 1 survey online
                    surveyOnline = $("#ddlSurveyOnline option:selected").val() + ",";
                } else {
                    //Search all survey online with date from / to
                    $("#ddlSurveyOnline option").each(function () {
                        if (typeof $(this).val() !== "undefined" && $(this).val() !== '0')
                            surveyOnline += $(this).val() + ",";
                    });
                }
                surveyOnline = surveyOnline.replace('? undefined:undefined ?,', '');
                $scope.strSurOnlId = surveyOnline;

                //Check has data and show message
                if (surveyOnline == '' || surveyOnline == undefined) {
                    DisplayLoadPanel(ButtonText.Process);
                    DisplayErrorPanel(ValidText.ChooseSurveyConfirm);
                    $scope.reportSummaryFlag = true;
                    return;
                }

                // Clean up previous result in the view
                $scope.reportSurveyResults = [];
                $scope.reportSurveyResultSummary = [];

                // Get state list
                $(".chkProgressState").each(function () {
                    if ($(this).attr('checked')) {
                        state += $(this).val() + ",";
                        $(this).attr('checked', 'checked');
                    } else {
                        $(this).removeAttr("checked");
                    }
                });
                $scope.strState = state;

                $(".overlay-loading, .modal-loading").show();
                // call ajax to get data
                $http.get(APP_ROOT + "api/SurveyReportResults/ReportSummary?surveyOnlineId=" + surveyOnline + "&progressStateId=" + state + "&langId=" + $attrs.langid + "&" + getDateFromToFilterParam())
                    .success(function (data) {
                        $scope.reportSurveyResultSummary = data;

                        $(".overlay-loading, .modal-loading").hide();
                        //initUniform("input[type=text],input[type=checkbox], #reportServeyResults, #reportSurveyResultSummary, .btnTextButton");
                        //initUniform("input[type=text],input[type=checkbox], #reportServeyResults, #reportSurveyResultSummary, #dateChartSurvey, #exportPDF, #exportExcel, #exportExcelMatrix, .btnTextButton");

                        //setTimeout(CollapseAllReports, 300);

                        setTimeout(CalcParticipation(surveyOnline, state), 300);
                        $scope.reportSummaryFlag = true;
                    }).error(function (data) {
                        console.log('fail');
                        $scope.reportSummaryFlag = true;
                        $(".overlay-loading, .modal-loading").hide();
                    });

            };

            function CalcParticipation(surveyOnlineIds, progressStateIds) {
                //call function to get data count total
                $http.get(APP_ROOT + "api/SurveyReportResults/GetParticipation?surveyOnlineId=" + surveyOnlineIds + "&progressStateId=" + progressStateIds + "&" + getDateFromToFilterParam())
                       .success(function (data) {
                           $scope.participations = data;
                       }).error(function (data) {
                           console.log('fail get calc participation');
                           $scope.reportFlag = true;
                       });
            }

            function CollapseAllReports() {
                //overlay-loading
                $(".overlay-loading, .modal-loading-temp").show();
                $("#ReportResults .expList h2").each(function () {
                    if ($scope.flagLoadAllResults == false) {
                        $(this).addClass('expanded');
                        $(this).nextAll().hide();
                    } else {
                        $(this).removeClass('expanded');
                        $(this).nextAll().show();
                    }

                });
                $scope.chkAllResultChange();
                $(".overlay-loading, .modal-loading-temp").fadeOut(1500);
            }

            $scope.ColAndExpReports = function () {
                CollapseAllReports();
            };

            $scope.pSize = 5;
            $scope.loadTextFlag = true;     //This field prevent duplicate event loadText
            $scope.loadText = function (obj) {
                if (!$scope.loadTextFlag) return;
                $scope.loadTextFlag = false;

                var div = $("#div" + obj.MainSurveyId + obj.MainStructureId + obj.MainQuestionId + obj.MainAnswerId);
                var hf = $("#hf" + obj.MainSurveyId + obj.MainStructureId + obj.MainQuestionId + obj.MainAnswerId);
                var pageIndex = parseInt(hf.val());
                var iflage = parseInt(hf.val()) + 1;
               
                var surveyOnlineIds = getListSurveyOnlineIds();

                $http.get(APP_ROOT + "api/SurveyLoadText/loadText?surveyId=" + obj.MainSurveyId + "&questionId=" + obj.MainQuestionId + "&answerId=" + obj.MainAnswerId + "&pageIndex=" + pageIndex + "&pageSize=" + $scope.pSize + "&progressState=" + $scope.strState + "&surveyOnlineIds=" + surveyOnlineIds + "&" + getDateFromToFilterParam())
                      .success(function (data) {
                          $(".overlay-loading, .modal-loading").show();
                         
                          if (data != null) {
                              for (var i = 0; i < data.length; i++) {
                                  div.append("<p>[" + parseDateToStringFormat(data[i].AnsDate) + "]</p>");
                                  div.append("<p>\"" + data[i].AnsValue + "\"</p>");
                                  div.append("<p>------------------------------------------</p>");
                              }

                              $("#btnShowText_" + obj.MainSurveyId + "_" + obj.MainStructureId + "_" + obj.MainQuestionId + "_" + obj.MainAnswerId).attr('value', ValidText.ShowMoreAnswerButton);
                              if (iflage * $scope.pSize >= data[0].Total) {
                                  $("#uniform-btnShowText_" + obj.MainSurveyId + "_" + obj.MainStructureId + "_" + obj.MainQuestionId + "_" + obj.MainAnswerId).css("display", "none");
                                  $("#btnShowText_" + obj.MainSurveyId + "_" + obj.MainStructureId + "_" + obj.MainQuestionId + "_" + obj.MainAnswerId).attr("disabled", "disabled");
                                  $("#btnShowText_" + obj.MainSurveyId + "_" + obj.MainStructureId + "_" + obj.MainQuestionId + "_" + obj.MainAnswerId).css('visibility', 'hidden');
                              }
                              hf.val(parseInt(pageIndex) + 1);
                          }

                          $(" .overlay-loading,.modal-loading").fadeOut(1500);
                          
                          $scope.loadTextFlag = true;
                      }).error(function (data) {
                          $scope.loadTextFlag = true;
                          console.log('fail');
                      });

            };

            $scope.loadPersonInfoFlag = true;   //This field prevent duplicate event loadPersonInfo
            $scope.loadPersonInfo = function (obj) {
                if (!$scope.loadPersonInfoFlag) return;
                $scope.loadPersonInfoFlag = false;

                var div = $("#PersonInfo" + obj.MainSurveyId + obj.MainStructureId + obj.MainQuestionId);
                var hf = $("#PersonHf" + obj.MainSurveyId + obj.MainStructureId + obj.MainQuestionId);
                var pageIndex = parseInt(hf.val());
                var iflage = parseInt(hf.val()) + 1;

                var surveyOnlineIds = getListSurveyOnlineIds();

                $http.get(APP_ROOT + "api/SurveyLoadText/loadPersonInfo?surveyId=" + obj.SurveyId + "&pageIndex=" + pageIndex + "&pageSize=" + $scope.pSize + "&surveyOnlineIds=" + surveyOnlineIds + "&" + getDateFromToFilterParam())
                      .success(function (data) {
                          $(".overlay-loading, .modal-loading").show();

                          if (data != null) {
                              for (var i = 0; i < data.length; i++) {
                                  div.append("<p>[" + parseDateToStringFormat(data[i].FinishDate) + "]</p>");
                                  div.append("<p>[" + data[i].ContactId + "]     " + data[i].Email + "</p>");
                                  div.append("<p>\"" + data[i].Info + "\"</p>");
                                  div.append("<p>------------------------------------------</p>");
                              }

                              //update pageIndex
                              if (iflage * $scope.pSize >= data[0].Total) {
                                  $("#btnShowPersonInfo_" + obj.MainSurveyId + "_" + obj.MainStructureId + "_" + obj.MainQuestionId).attr("disabled", "disabled");
                                  $("#btnShowPersonInfo_" + obj.MainSurveyId + "_" + obj.MainStructureId + "_" + obj.MainQuestionId).css('visibility', 'hidden');
                              }
                              hf.val(parseInt(pageIndex) + 1);
                          }

                          $(".overlay-loading, .modal-loading").fadeOut(1500);
                          
                          $scope.loadPersonInfoFlag = true;
                      }).error(function (data) {
                          $scope.loadPersonInfoFlag = true;
                          console.log('fail');
                      });
            };

            $scope.exportPdfFlag = true;    //This field prevent duplicate event exportPDF
            $scope.exportPDF = function () {
                if (!$scope.exportPdfFlag) return;
                $scope.exportPdfFlag = false;
                
                if ($scope.reportSurveyResults != '') {
                    if ($scope.summaryId > 0) {
                        //Export with 1 contact
                        //Expand all the html
                        if ($scope.flagLoadAllResults == false) {
                            $scope.flagLoadAllResults = true;
                            $("#ReportResults .expList h2").each(function () {
                                $(this).removeClass('expanded');
                                $(this).nextAll().show();
                                $scope.chkAllResultChange();
                            });
                        }
                        //Hide the button
                        $scope.showHideHTML('hide');
                        // trigger hide for element in pdf
                        $('.ng-hide').hide();

                        //Get html results to export
                        var strHtml = $("#surveyDetailPage").html();
                        var postData = { surveyName: $scope.editingSurvey.SurveyName, html: strHtml, summaryid: $scope.summaryId, langId: $attrs.langid };
                        $(".overlay-loading, .modal-loading-temp").show();

                        $http.post(APP_ROOT + 'api/surveyexporttopdf/POST/', postData)
                            .success(function (data) {
                                if (data > 0) {
                                    window.open(APP_ROOT + 'api/surveyexporttopdf/ExportToPDF?input=' + "contact");
                                    $(".overlay-loading, .modal-loading-temp").fadeOut(1500);

                                    $("#exportPDF").show();
                                    $("#exportExcel").show();

                                    $scope.exportPdfFlag = true;
                                }
                            }).error(function (data) {
                                $scope.exportPdfFlag = true;
                                console.log('fail');
                            });

                    } else {
                        //Export general Survey
                        //Load all Text and add to Promise + $q
                        var promises = [];
                        if ($scope.flagLoadAllText == false)
                            promises = loadAllTextAndContact();

                        $q.all(promises).then(function () {
                            $(".overlay-loading, .modal-loading").show();
                            //Expand all the html
                            if ($scope.flagLoadAllResults == false) {
                                $scope.flagLoadAllResults = true;
                                $("#ReportResults .expList h2").each(function () {
                                    $(this).removeClass('expanded');
                                    $(this).nextAll().show();
                                });
                                $scope.chkAllResultChange();
                            }
                            //Hide the button and elm
                            $scope.showHideHTML('hide');
                            // trigger hide for element in pdf
                            $('.ng-hide').hide();
                            handleDataForPdf(true);

                            //Get html results to export
                            var strHtml = $("#surveyDetailPage").html();
                            var postData = { surveyName: $scope.editingSurvey.SurveyName, html: strHtml, summaryid: '0', langId: $attrs.langid };
                            $(".overlay-loading, .modal-loading-temp").show();
                            
                            $http.post(APP_ROOT + 'api/surveyexporttopdf/POST/', postData)
                                .success(function (data) {
                                    if (data > 0) {
                                        window.open(APP_ROOT + 'api/surveyexporttopdf/ExportToPDF?input=' + "");
                                        $(".overlay-loading, .modal-loading-temp").fadeOut(1500);
                                        $scope.showHideHTML('show');
                                        
                                        $scope.exportPdfFlag = true;
                                        handleDataForPdf(false);
                                    }
                                }).error(function (data) {
                                    $scope.exportPdfFlag = true;
                                    console.log('fail');
                                    handleDataForPdf(false);
                                });
                        });

                    }

                } else {
                    alert('Please report the survey first !!!');
                }
                
            };

            $scope.exportToExcelFlag = true;    //This field prevent duplicate event exportToExcel
            $scope.exportToExcel = function () {
                if (!$scope.exportToExcelFlag) return;
                $scope.exportToExcelFlag = false;
                
                $(".overlay-loading,.modal-loading").show();

                if ($scope.summaryId > 0)
                    //Export for 1 Contact Survey
                    window.open(APP_ROOT + 'api/surveyexporttopdf/ExprtToExcel?surveyOnlineId=&progressStateId=&surveyName=$scope.editingSurvey.SurveyName' + "&langId=" + $attrs.langid + "&summaryId=" + $scope.summaryId + "&date=" + +"&chk1Survey=" + 0 + "&" + getDateFromToFilterParam());
                else {
                    //Export for General Survey
                    var dateFromCH = '', dateToCH = '', chk1Survey = 0, dateFromTo = '';
                    if ($scope.searchParams.DateFrom != '' && $scope.searchParams.DateFrom != undefined)
                        dateFromCH = parseDateToString2($scope.searchParams.DateFrom);
                    if ($scope.searchParams.DateTo != '' && $scope.searchParams.DateTo != undefined)
                        dateToCH = parseDateToString2($scope.searchParams.DateTo);
                    if ($scope.flagSearchOne == true)
                        chk1Survey = 1;
                    dateFromTo = dateFromCH + "," + dateToCH;

                    window.open(APP_ROOT + 'api/surveyexporttopdf/ExprtToExcel?surveyOnlineId=' + $scope.strSurOnlId + "&progressStateId=" + $scope.strState + "&surveyName=" + $scope.editingSurvey.SurveyName + "&langId=" + $attrs.langid + "&summaryId=" + 0 + "&date=" + dateFromTo + "&chk1Survey=" + chk1Survey + "&" + getDateFromToFilterParam());
                }
                $(".overlay-loading, .modal-loading").fadeOut(1500);

                setTimeout(function () {
                    $scope.exportToExcelFlag = true;
                }, 500);
            };

            $scope.loadAllText = function () {
                loadAllTextAndContact();
            };

            //This function use $q to chain the ajax request together
            function loadAllTextAndContact() {
                var promises = [];
                var surveyOnlineIds = getListSurveyOnlineIds();

                //Get all the button with class name to show Contact Infomations
                $(".isContactInfo").each(function () {
                    var divConButton = $(this);
                    var strConId = divConButton.attr('id');
                    var arrConStrId = strConId.split('_');

                    var surveyConId = arrConStrId[1];
                    var structureConId = arrConStrId[2];
                    var questionConId = arrConStrId[3];
                    var answerConId = arrConStrId[4];

                    var deferred = $q.defer();

                    var divCon = $("#PersonInfo" + surveyConId + structureConId + questionConId);

                    $http.get(APP_ROOT + "api/SurveyLoadText/loadPersonInfo?surveyId=" + surveyConId + "&pageIndex=" + 0 + "&pageSize=" + 1000 + "&surveyOnlineIds=" + surveyOnlineIds + "&" + getDateFromToFilterParam())
                                .success(function (data) {
                                    if (data != null) {
                                        for (var i = 0; i < data.length; i++) {
                                            divCon.append("<div>[" + parseDateToStringFormat(data[i].FinishDate) + "]</div>");
                                            divCon.append("<div>[" + data[i].ContactId + "]     " + data[i].Email + "</div>");
                                            divCon.append("<div>\"" + data[i].Info + "\"</div>");
                                            divCon.append("<div style='margin-bottom:4px;line-height:10px' class='cu-GrayText'>------------------------------------------</div>");
                                        }
                                        divConButton.attr("disabled", "disabled");
                                        divConButton.css('visibility', 'hidden');
                                    }
                                    deferred.resolve();
                                }).error(function (data) {
                                    console.log('fail');
                                    deferred.reject();
                                });
                    promises.push(deferred.promise);
                });

                //Get all the button with class name show text
                $(".clsHasInputValue").each(function () {
                    var divButton = $(this);
                    var strId = divButton.attr('id');
                    var arrStrId = strId.split('_');

                    var surveyId = arrStrId[1];
                    var structureId = arrStrId[2];
                    var questionId = arrStrId[3];
                    var answerId = arrStrId[4];

                    var div = $("#div" + surveyId + structureId + questionId + answerId);

                    var deferred = $q.defer();

                    //loop to get all the text
                    $http.get(APP_ROOT + "api/SurveyLoadText/loadText?surveyId=" + surveyId + "&questionId=" + questionId + "&answerId=" + answerId + "&pageIndex=" + 0 + "&pageSize=" + 1000 + "&progressState=" + $scope.strState + "&surveyOnlineIds=" + surveyOnlineIds + "&" + getDateFromToFilterParam())
                        .success(function (data) {
                            if (data != null) {
                                for (var i = 0; i < data.length; i++) {
                                    div.append("<div>[" + parseDateToStringFormat(data[i].AnsDate) + "]</div>");
                                    div.append("<div>\"" + data[i].AnsValue + "\"</div>");
                                    div.append("<div style='margin-bottom:4px;line-height:10px' class='cu-GrayText'>------------------------------------------</div>");
                                }

                                $('#uniform-' + divButton.id).css('display', 'none');
                                divButton.attr("disabled", "disabled");
                                divButton.css('visibility', 'hidden');
                                deferred.resolve();
                            }
                        }).error(function (data) {
                            console.log('fail');
                            deferred.reject();
                        });
                    promises.push(deferred.promise);
                });

                $scope.flagLoadAllText = true;
                $scope.chkAllText();
                return promises;
            }

            function getListSurveyOnlineIds() {
                var surveyOnline = "";
                if ($scope.flagSearchOne) {
                    //Search 1 survey online
                    surveyOnline = $("#ddlSurveyOnline option:selected").val() + ",";
                } else {
                    //Search all survey online with date from / to
                    $("#ddlSurveyOnline option").each(function () {
                        surveyOnline += $(this).val() + ",";
                    });

                }
                surveyOnline = surveyOnline.replace('? undefined:undefined ?,', '');
                $scope.strSurOnlId = surveyOnline;

                return surveyOnline;
            }

            function getDateFromToFilterParam() {
                var dateFrom = $scope.searchParams.DateFrom;
                var dateTo = $scope.searchParams.DateTo;
                if (typeof dateFrom != "undefined" && dateFrom != null && dateFrom !== '') {
                    dateFrom = parseDateToString(dateFrom);
                } else {
                    dateFrom = "";
                }
                if (typeof dateTo != "undefined" && dateTo != null && dateTo !== '') {
                    dateTo = parseDateToString(dateTo);
                } else {
                    dateTo = "";
                }

                return "dateFrom=" + dateFrom + "&dateTo=" + dateTo;
            }

            //Check show header comment
            $scope.checkShowHeaderTable = function(headerAnswer, index) {
                var arrAnswer = headerAnswer.split('#@#');
                if (arrAnswer.length > 0) {
                    if (index <= arrAnswer.length - 1)
                        return true;
                }
                return false;
            };

            //Uniform
            function initUniform(keys) {
                $(keys).uniform();
            }

            function updateUniform(keys) {
                $(keys).uniform.update();
            }

            $scope.showBtnOnListSurvey = function (elmId) {
                if ($scope.reportSurveyResults != '' && $scope.reportSurveyResults.length > 0) {
                    $('#' + elmId).css('display', '');
                    $('#uniform-' + elmId).css('display', '');
                } else {
                    $('#' + elmId).css('display', 'none');
                    $('#uniform-' + elmId).css('display', 'none');
                }
                //return $scope.reportSurveyResults.length > 0;
            };

            $scope.showBtnOnSearchOne = function (value, elm) {
                if (value == true) {
                    $('#uniform-exportExcelMatrix').css('display', '');
                    $('#' + elm).css('display', '');
                    $('#' + elm).uniform();
                } else {
                    $('#uniform-exportExcelMatrix').css('display', 'none');
                    $('#' + elm).css('display', 'none');
                }

            };

            function showHideElm(isShow, $listElms) {
                $.each($listElms, function (index, item) {
                    if (isShow) {
                        item.show();
                    } else {
                        item.hide();
                    }
                });
            }

           function handleDataForPdf(isBefore) {
                var $dateFilter = $('#td-date-filter');
                var $searchOne = $('#td-search-one');
                var $serveyOnline = $('#td-survey-online');
                var $surveyState = $('#td-survey-state');

                if (isBefore) {
                    var surveyDateFrom = parseDateToString2($scope.searchParams.DateFrom);
                    var surveyDateTo = parseDateToString2($scope.searchParams.DateTo);
                    var dateSlash = "";
                    if ((typeof surveyDateFrom !== "undefined" && surveyDateFrom !== '') && (typeof surveyDateTo !== "undefined" && surveyDateTo !== ''))
                        dateSlash = " / ";
                    $dateFilter.after('<td class="cu-standardheader cu-formlabel" ><div>' + surveyDateFrom + dateSlash + surveyDateTo + '</div></td>');

                    var labelChkCheckone = $('#label-chk-searh-one').text();
                   
                    if($scope.flagSearchOne){
                        $searchOne.after('<td class="cu-standardheader cu-formlabel"><div>' + 'X ' + labelChkCheckone + '</div></td>');
                        $serveyOnline.after('<td class="cu-standardheader cu-formlabel"><div>' + $("#ddlSurveyOnline :selected").text() + '</div></td>');
                    }

                    var surveyState = '';
                    $(".chkProgressState").each(function () {
                        if ($(this).attr('checked')) {
                            var $chkDivParent = $(this).closest('div');
                            var labelState = $chkDivParent.next('label').text();

                            if (surveyState === '') {
                                surveyState = labelState;
                            } else {
                                surveyState += ', ' + labelState;
                            }
                        } 
                    });
                    $surveyState.after('<td class="cu-standardheader cu-formlabel"><div>' + surveyState + '</div></td>');

                    showHideElm(false, [$('.hideforPDF'), $dateFilter, $searchOne, $serveyOnline, $surveyState]);
                } else {
                    showHideElm(true, [$('.hideforPDF'), $dateFilter, $searchOne, $serveyOnline, $surveyState]);
                    $dateFilter.next('td').remove();
                    $searchOne.next('td').remove();
                    $serveyOnline.next('td').remove();
                    $surveyState.next('td').remove();
                }
            }
            //----------------------------------------------------------------------------------- Handle logic 
            function parseDateToString(date) {
                var stringdate = '';
                if (date instanceof Date) {
                    var yyyy = date.getFullYear().toString();
                    var mm = (date.getMonth() + 1).toString();
                    var dd = date.getDate().toString();
                    return stringdate = yyyy + '-' + mm + '-' + dd + ' 00:00:00';
                }
                return stringdate;
            }

            function parseDateToString2(date) {
                var stringdate = '';
                if (date instanceof Date) {
                    var yyyy = date.getFullYear().toString();
                    var mm = (date.getMonth() + 1).toString();
                    var dd = date.getDate().toString();
                    return stringdate = dd + '.' + mm + '.' + yyyy;
                }
                return stringdate;
            }

            function parseDateToStringFormat(date) {
                var stringdate = '';
                if (date != '' && date != undefined) {
                    var splitdate = date.split('T');
                    var strdate = splitdate[0].split('-');
                    var strTime = splitdate[1].split(':');

                    var year = strdate[0].toString();
                    var month = strdate[1].toString();
                    var day = strdate[2].toString();

                    var hour = strTime[0].toString();
                    var minute = strTime[1].toString();
                    var second = strTime[2].toString();

                    stringdate = day + '.' + month + '.' + year + ' ' + hour + ':' + minute + ':' + second;
                }

                return stringdate;
            }

            function parseDateToStringFormat2(date) {
                var stringdate = '';
                if (date != '' && date != undefined) {
                    var splitdate = date.split('T');
                    var strdate = splitdate[0].split('-');
                    var strTime = splitdate[1].split(':');

                    var year = strdate[0].toString();
                    var month = strdate[1].toString();
                    var day = strdate[2].toString();

                    stringdate = day + '.' + month + '.' + year;
                }

                return stringdate;
            }

            function parseDateToDateMonthFormat(date) {
                var stringdate = '';
                if (date != '' && date != undefined) {
                    var splitdate = date.split('.');

                    var month = splitdate[1].toString();
                    var day = splitdate[0].toString();

                    stringdate = day + '.' + month;
                }

                return stringdate;
            }

            $scope.backtoList = function () {
                //$scope.editingSurvey = {};
                //$scope.reportSurveyResults = [];
                //$scope.flagedit = 1;

                window.location.reload();
            };

            $scope.mySplit = function (string, ind) {
                $scope.arraySplit = string.split('#@#');
                return $scope.result = $scope.arraySplit[ind];
            };

            $scope.chkSearch1Change = function () {
                if ($scope.flagSearchOne == true)
                    $("#chkSearchOne").attr("checked", "checked");
                else
                    $("#chkSearchOne").removeAttr("checked");
            };

            $scope.chkAllResultChange = function () {
                //Set attr checked for checkbox
                if ($scope.flagLoadAllResults == false)
                    $("#chkAllResults").removeAttr('checked');
                else
                    $("#chkAllResults").attr('checked', 'checked');
            };

            $scope.chkAllText = function () {
                if ($scope.flagLoadAllText == true) {
                    $("#chkAllText").attr('checked', 'checked');
                    $("#chkAllText").attr('disabled', 'disabled');
                    $('#divCheckLoadAllText').css('display', 'none');
                    $('#divReloadOfLoadAllText').css('display', '');
                } else {
                    $("#chkAllText").removeAttr('checked');
                    $("#chkAllText").removeAttr('disabled');
                    $('#divCheckLoadAllText').css('display', '');
                    $('#divReloadOfLoadAllText').css('display', 'none');
                }
            };

            $scope.showHideHTML = function (flag) {
                if (flag == 'hide') {
                    $("input[type='button']").hide();
                    $(".iconChart").hide();
                } else if (flag == 'show') {
                    $("input[type='button']").show();
                    $(".iconChart").show();
                }
            };

            $scope.returnTotalPerson = function (obj) {
                var total = '';

                if ($scope.summaryId > 0) {
                    //Do nothing with 1 contact report
                } else {
                    if (obj != null && obj.TotalPersonTakePart > 0) {
                        total = '(' + obj.TotalPersonTakePart + ' ' + ValidText.AnswerText + ')';
                    } else if (obj.Children != null && obj.Children[0].TotalPersonTakePart > 0) {
                        total = '(' + obj.Children[0].TotalPersonTakePart + ' ' + ValidText.AnswerText + ')';
                    } else if (obj.Children[0].Children != null && obj.Children[0].Children[0].TotalPersonTakePart > 0) {
                        total = '(' + obj.Children[0].Children[0].TotalPersonTakePart + ' ' + ValidText.AnswerText + ')';
                    }
                }

                return total;
            };
            //----------------------------------------------------------------------------------- Handle Question Matrix Level 1
            $scope.checkAnswerIsHasText = function (questionLevel1) {
                if (questionLevel1.Children == null || questionLevel1.Children.length <= 0) return false;

                for (var i = 0; i < questionLevel1.Children.length; i++) {
                    if (questionLevel1.Children[i].AnswerId > 0 && (questionLevel1.Children[i].HasInputValue == true || questionLevel1.Children[i].AnswerType == 2))
                        return true;
                }
                return false;
            };

            //----------------------------------------------------------------------------------- Load Survey with 1 Contact

            $scope.getContactSurvey = function () {
                $http.get(APP_ROOT + "api/SurveyReportWithContact/GetList?summaryId=" + $scope.summaryId + "&langId=" + $attrs.langid)
                      .success(function (data) {
                          $scope.reportSurveyResults = data;
                          setTimeout(CollapseAllReports, 300);
                          GetSummary();
                      }).error(function (data) {
                          console.log('fail');
                      });
            };

            $scope.listSummary = [];
            function GetSummary() {
                $http.get(APP_ROOT + "api/SurveySummary/Get?summaryId=" + $attrs.summaryid)
                        .success(function (data) {
                            $scope.listSummary = data;
                        }).error(function (data) {
                            console.log('fail');
                        });

            }

            //----------------------------------------------------------------------------------- Export Excel Matrix
            $scope.exportExcelMatrixFlag = true;    //This field prevent duplicate event exportExcelMatrix
            $scope.exportExcelMatrix = function () {
                if (!$scope.exportExcelMatrixFlag) return;
                $scope.exportExcelMatrixFlag = false;

                var surveyOnline = '';
                surveyOnline = $("#ddlSurveyOnline option:selected").val();
                surveyOnline = surveyOnline.replace('? undefined:undefined ?', '');

                //Check Survey has data SurveyOnline and show message
                if ($scope.dllSurveyOnline == '' || $scope.dllSurveyOnline == null) {
                    DisplayLoadPanel(ButtonText.Process);
                    DisplayErrorPanel(ValidText.HasNoSurveyOnline);
                    $scope.exportExcelMatrixFlag = true;
                    return;
                }

                if (surveyOnline == '' || surveyOnline == undefined) {
                    DisplayLoadPanel(ButtonText.Process);
                    DisplayErrorPanel(ValidText.ChooseSurveyConfirm);
                    $scope.exportExcelMatrixFlag = true;
                    return;
                }

                var dateFromCH = '', dateToCH = '', chk1Survey = 0, dateFromTo = '';
                if ($scope.searchParams.DateFrom != '' && $scope.searchParams.DateFrom != undefined)
                    dateFromCH = parseDateToString2($scope.searchParams.DateFrom);
                if ($scope.searchParams.DateTo != '' && $scope.searchParams.DateTo != undefined)
                    dateToCH = parseDateToString2($scope.searchParams.DateTo);
                dateFromTo = dateFromCH + "," + dateToCH;
                $(".overlay-loading, .modal-loading").show();
                window.open(APP_ROOT + 'api/SurveyReportWithContact/ExprtToExcelMatrix?langId=' + $attrs.langid + "&surveyOnlineID=" + surveyOnline + "&date=" + dateFromTo + "&surveyName=" + $scope.editingSurvey.SurveyName + "&" + getDateFromToFilterParam());

                $(".overlay-loading, .modal-loading").fadeOut(1500);
                $scope.exportExcelMatrixFlag = true;
            };

            //----------------------------------------------------------------------------------- Survey Chart
            $modalChart = $('#Survey-Chart');
            $modalLineChart = $('#Survey-Line-Chart');

            $scope.chartType = 1;
            $scope.chartObj = [];
            $scope.isPercent = 1;

            $scope.showChart = function (obj) {
                $modalChart.modal('show');
                $scope.chartObj = [];
                $scope.chartObj = obj;

                //Alway load BarChart first when open popup
                $scope.chartType = 1;
                $scope.isPercent = 1;
                refreshChart("barChart");
                $scope.barChart($scope.chartObj, $scope.isPercent);
            };

            $scope.$watch('chartType', function (newVal, oldVal) {

                if (newVal == oldVal) return;

                if (newVal == '1') {
                    refreshChart("barChart");
                    $scope.barChart($scope.chartObj, $scope.isPercent);
                }
                else if (newVal == '2') {
                    refreshChart("pieChart");
                    $scope.pieChart($scope.chartObj, $scope.isPercent);
                }
                else if (newVal == '3') {
                    refreshChart("barAndLineChart");
                    $scope.barAndLineChart($scope.chartObj);
                }
                else if (newVal == '4') {
                    refreshChart("stackChart");
                    $scope.stackChart($scope.chartObj, $scope.isPercent);
                }

            });

            $scope.$watch('isPercent', function (newVal, oldVal) {

                if (newVal == oldVal) return;

                if ($scope.chartType == '1') {
                    refreshChart("barChart");
                    $scope.barChart($scope.chartObj, newVal);
                }
                else if ($scope.chartType == '2') {
                    refreshChart("pieChart");
                    $scope.pieChart($scope.chartObj, newVal);
                }
                else if ($scope.chartType == '4') {
                    refreshChart("stackChart");
                    $scope.stackChart($scope.chartObj, $scope.isPercent);
                }

            });

            $scope.barChart = function (question, isPercent) {
                var title = $scope.editingSurvey.SurveyName; //+ " - " + parseDateToStringFormat2($scope.editingSurvey.DateCreated);
                var subTitle = question.Name;
                var cate = [];
                var dataSeries = [];
                var subTitleDate = getSubTitleDate();
                
                //Header Answer
                var flagHeaderAnswerType7 = false;
                if (typeof question.HeaderAnswer != "undefined" && question.HeaderAnswer.indexOf('#@#') > 0)
                    flagHeaderAnswerType7 = true;
                var headCommentArr = question.Comment.split(',');
                var idCheckForSubTooltip = 7;

                if (question.Children[0].AnswerId > 0) {                                //Chart level 1

                    for (var i = 0; i < question.Children.length ; i++) {
                        var dataArr = new Array();
                        dataArr[0] = isPercent == 1 ? question.Children[i].Cal : question.Children[i].Persion;
                        var obj = { name: question.Children[i].Name, data: dataArr };
                        dataSeries[i] = obj;
                    }
                    cate[0] = question.Name;
                }
                else if (question.Children[0].Children[0] != null && question.Children[0].Children[0].AnswerId > 0) {               //Chart level 2

                    //Get Category
                    for (var i = 0; i < question.Children.length ; i++) {
                        cate[i] = question.Children[i].Name;
                    }

                    //Get answername
                    var answerNameArr = new Array();
                    for (var k = 0; k < question.Children[0].Children.length; k++) {
                        if (flagHeaderAnswerType7 == true && question.Children[0].Children[k].AnswerType == idCheckForSubTooltip)
                            answerNameArr[k] = assignHeaderWithName(question.Children[0].Children[k].Name, headCommentArr, '', '');
                        else
                            answerNameArr[k] = question.Children[0].Children[k].Name;
                    }

                    //Get category and data
                    for (var l = 0; l < answerNameArr.length; l++) {
                        var dataArr = new Array();
                        for (var n = 0; n < question.Children.length ; n++) {
                            if (typeof question.Children[n].Children[l] != "undefined")
                                dataArr[n] = isPercent == 1 ? question.Children[n].Children[l].Cal : question.Children[n].Children[l].Persion;
                        }

                        dataSeries[l] = { name: answerNameArr[l], data: dataArr };
                    }
                }
                else if (question.Children[0].Children[0].Children[0] != null && question.Children[0].Children[0].Children[0].AnswerId > 0) {               //Chart level 3
                    //Get answername
                    var answerNameArr = new Array();
                    for (var k = 0; k < question.Children[0].Children[0].Children.length; k++) {
                        answerNameArr[k] = question.Children[0].Children[0].Children[k].Name;
                    }

                    //Get Category
                    var count = 0;
                    for (var i = 0; i < question.Children.length ; i++) {
                        for (var j = 0; j < question.Children[i].Children.length; j++) {
                            cate[count] = question.Children[i].Name + " - " + question.Children[i].Children[j].Name;
                            count++;
                        }
                    }

                    //Get category and data
                    for (var l = 0; l < answerNameArr.length; l++) {
                        var count = 0;
                        var dataArr = new Array();

                        for (var n = 0; n < question.Children.length ; n++) {
                            for (var m = 0; m < question.Children[n].Children.length ; m++) {
                                dataArr[count] = isPercent == 1 ? question.Children[n].Children[m].Children[l].Cal : question.Children[n].Children[m].Children[l].Persion;
                                count++;
                            }
                        }

                        dataSeries[l] = { name: answerNameArr[l], data: dataArr };
                    }

                }

                //write Bar Chart
                var yText = isPercent == 1 ? ValidText.BarChartPercentRank : ValidText.BarChartPersonRank;
                var tooltipText = isPercent == 1 ? '%' : ValidText.TooltipChartPerson;
                writeBarChart(title, subTitle, cate, dataSeries, yText, tooltipText, subTitleDate);
            };

            function writeBarChart(title, subTitle, cate, dataSeries, yText, tooltipText, subTitleDate) {

                $('#barChart').highcharts({
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: title
                    },
                    subtitle: {
                        text: subTitleDate == " / " ? subTitle : (ValidText.GerneralTextDate + " : " + subTitleDate + "<br>") + subTitle
                    },
                    xAxis: {
                        categories: cate
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: yText
                        }
                    },
                    tooltip: {
                        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                            '<td style="padding:0"><b>{point.y:.1f} ' + tooltipText + '</b></td></tr>',
                        footerFormat: '</table>',
                        shared: true,
                        useHTML: true,
                        positioner: function () {
                            return { x: 65, y: 80 };
                        }
                    },
                    plotOptions: {
                        column: {
                            dataLabels: {
                                enabled: true
                            },
                            pointPadding: 0.2,
                            borderWidth: 0
                        }
                    },
                    series: dataSeries,
                    exporting: {
                        buttons: {
                            contextButton: {

                                menuItems: [
                                    { text: ValidText.ContextMenuPrintChart, textKey: "printChart", onclick: function () { this.print() } }, { separator: !0 },
                                    { text: ValidText.ContextMenuPNG, textKey: "downloadPNG", onclick: function () { this.exportChart() } },
                                    { text: ValidText.ContextMenuJPEG, textKey: "downloadJPEG", onclick: function () { this.exportChart({ type: "image/jpeg" }) } },
                                    { text: ValidText.ContextMenuPDF, textKey: "downloadPDF", onclick: function () { this.exportChart({ type: "application/pdf" }) } },
                                    { text: ValidText.ContextMenuSVG, textKey: "downloadSVG", onclick: function () { this.exportChart({ type: "image/svg+xml" }) } }
                                ]
                            }
                        },
                        sourceWidth: 1000,
                        sourceHeight: 600
                    }
                });
            }

            $scope.pieChart = function (question, isPercent) {
                var title = $scope.editingSurvey.SurveyName; // + " - " + parseDateToStringFormat2($scope.editingSurvey.DateCreated);
                var subTitle = question.Name;
                var flagLevel1 = false;
                var subTitleDate = getSubTitleDate();

                //Handle to add more for the HighChart color 
                var colors = Highcharts.getOptions().colors;
                var maxColorLengh = colors.length - 1;
                var subColors = ['#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4', '#EAEAEA', '#666999', '#006699'];
                for (var k = 0; k < subColors.length; k++) {
                    colors[maxColorLengh + k] = subColors[k];
                }
                
                //Header Answer
                var flagHeaderAnswerType7 = false;
                if (typeof question.HeaderAnswer != "undefined" && question.HeaderAnswer.indexOf('#@#') > 0)
                    flagHeaderAnswerType7 = true;
                var headCommentArr = question.Comment.split(',');
                var idCheckForSubTooltip = 7;

                var cate = [];
                var dataSeries = [];

                if (question.Children[0].AnswerId > 0) {                                                            //Pie level 1

                    cate = [question.Name];
                    var totalPercent = 0, cateAns = [], dataAns = [];
                    for (var i = 0; i < question.Children.length ; i++) {
                        totalPercent += isPercent == 1 ? question.Children[i].Cal : question.Children[i].Persion;
                        cateAns[i] = question.Children[i].Name;
                        dataAns[i] = isPercent == 1 ? question.Children[i].Cal : question.Children[i].Persion;
                    }

                    var obj = {
                        y: totalPercent,
                        color: colors[0],
                        drilldown: {
                            name: '',
                            categories: cateAns,
                            data: dataAns,
                            color: colors[0]
                        }
                    };
                    dataSeries[0] = obj;
                    flagLevel1 = true;

                }
                else if (question.Children[0].Children[0] != null && question.Children[0].Children[0].AnswerId > 0) { //Pie level 2
                    for (var i = 0; i < question.Children.length ; i++) {
                        cate[i] = question.Children[i].Name;

                        var totalPercent = 0, cateAns = [], dataAns = [];
                        for (var j = 0; j < question.Children[i].Children.length; j++) {
                            totalPercent += isPercent == 1 ? question.Children[i].Children[j].Cal : question.Children[i].Children[j].Persion;
                            
                            if (flagHeaderAnswerType7 == true && question.Children[i].Children[j].AnswerType == idCheckForSubTooltip)
                                cateAns[j] = assignHeaderWithName(question.Children[i].Children[j].Name, headCommentArr, '', '');
                            else
                                cateAns[j] = question.Children[i].Children[j].Name;
                            
                            dataAns[j] = isPercent == 1 ? question.Children[i].Children[j].Cal : question.Children[i].Children[j].Persion;
                        }

                        var obj = {
                            y: totalPercent,
                            color: colors[i],
                            drilldown: {
                                name: '',
                                categories: cateAns,
                                data: dataAns,
                                color: colors[i]
                            }
                        };

                        dataSeries[i] = obj;
                    }

                }
                else if (question.Children[0].Children[0].Children[0] != null && question.Children[0].Children[0].Children[0].AnswerId > 0) { //Chart level 3
                    var count = 0;
                    for (var i = 0; i < question.Children.length ; i++) {
                        var preName = question.Children[i].Name;

                        for (var j = 0; j < question.Children[i].Children.length; j++) {
                            cate[count] = question.Children[i].Name + "-" + question.Children[i].Children[j].Name;

                            var totalPercent = 0, cateAns = [], dataAns = [];
                            for (var l = 0; l < question.Children[i].Children[j].Children.length; l++) {
                                totalPercent += isPercent == 1 ? question.Children[i].Children[j].Children[l].Cal : question.Children[i].Children[j].Children[l].Persion;
                                cateAns[l] = question.Children[i].Children[j].Children[l].Name;
                                dataAns[l] = isPercent == 1 ? question.Children[i].Children[j].Children[l].Cal : question.Children[i].Children[j].Children[l].Persion;
                            }

                            var obj = {
                                y: totalPercent,
                                color: colors[count],
                                drilldown: {
                                    name: '',
                                    categories: cateAns,
                                    data: dataAns,
                                    color: colors[count]
                                }
                            };

                            dataSeries[count] = obj;

                            count++;
                        }
                    }
                }

                var valueSuff = isPercent == 1 ? '%' : ' ' + ValidText.TooltipChartPerson;
                writePieChart(title, subTitle, cate, dataSeries, valueSuff, colors, flagLevel1, subTitleDate);
            };

            function writePieChart(title, subTitle, cate, dataSeries, valueSuff, colors, flagLevel1, subTitleDate) {
                var categories = cate, data = dataSeries;//name = 'Browser brands',

                // Build the data arrays
                var answerData = [];
                var questionData = [];
                for (var i = 0; i < data.length; i++) {

                    // add questionData answerData
                    questionData.push({
                        name: categories[i],
                        y: data[i].y,
                        color: data[i].color
                    });

                    // add answerData
                    for (var j = 0; j < data[i].drilldown.data.length; j++) {
                        var brightness = 0.2 - (j / data[i].drilldown.data.length) / 5;
                        answerData.push({
                            name: data[i].drilldown.categories[j],
                            y: data[i].drilldown.data[j],
                            color: flagLevel1 == true ? colors[j + 1] : Highcharts.Color(data[i].color).brighten(brightness).get()
                        });

                    }
                }
                
                // Create the chart
                $('#pieChart').highcharts({
                    chart: {
                        type: 'pie',
                        marginBottom: 30,
                        marginLeft: 100,
                        marginRight: 100,
                        marginTop: 30
                    },
                    title: {
                        text: title
                    },
                    subtitle: {
                        text: subTitleDate == " / " ? subTitle : (ValidText.GerneralTextDate + " : " + subTitleDate + "<br>") + subTitle
                    },
                    yAxis: {
                        //title: {
                        //    text: textSubTitle
                        //}
                    },
                    plotOptions: {
                        pie: {
                            shadow: false,
                            center: ['50%', '50%']
                        }
                    },
                    tooltip: {
                        valueSuffix: valueSuff
                    },
                    series: [{
                        name: ValidText.ChartQuestionText,
                        data: questionData,
                        size: '60%',
                        dataLabels: {
                            formatter: function () {
                                return this.y > 5 ? this.point.name : null;
                            },
                            color: 'white',
                            distance: -30
                        }
                    }, {
                        name: ValidText.ChartAnswerText,
                        data: answerData,
                        size: '80%',
                        innerSize: '60%',
                        dataLabels: {
                            formatter: function () {
                                // display only if larger than 1
                                return this.y > 0 ? '<b>' + this.point.name + ':</b> ' + this.y + valueSuff : null;
                            }
                        }
                    }],
                    exporting: {
                        buttons: {
                            contextButton: {

                                menuItems: [
                                    { text: ValidText.ContextMenuPrintChart, textKey: "printChart", onclick: function () { this.print() } }, { separator: !0 },
                                    { text: ValidText.ContextMenuPNG, textKey: "downloadPNG", onclick: function () { this.exportChart() } },
                                    { text: ValidText.ContextMenuJPEG, textKey: "downloadJPEG", onclick: function () { this.exportChart({ type: "image/jpeg" }) } },
                                    { text: ValidText.ContextMenuPDF, textKey: "downloadPDF", onclick: function () { this.exportChart({ type: "application/pdf" }) } },
                                    { text: ValidText.ContextMenuSVG, textKey: "downloadSVG", onclick: function () { this.exportChart({ type: "image/svg+xml" }) } }
                                ]
                            }
                        },
                        sourceWidth: 1000,
                        sourceHeight: 600
                    }
                });
            }

            $scope.barAndLineChart = function (question) {
                var title = $scope.editingSurvey.SurveyName; // + " - " + parseDateToStringFormat2($scope.editingSurvey.DateCreated);
                var subTitle = question.Name;
                var subTitleDate = getSubTitleDate();

                //Handle to add more for the HighChart color 
                var colors = Highcharts.getOptions().colors;
                var maxColorLengh = colors.length - 1;
                var subColors = ['#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4', '#EAEAEA', '#666999', '#006699'];
                for (var k = 0; k < subColors.length; k++) {
                    colors[maxColorLengh + k] = subColors[k];
                }

                //Header Answer
                var flagHeaderAnswerType7 = false;
                if (typeof question.HeaderAnswer != "undefined" && question.HeaderAnswer.indexOf('#@#') > 0)
                    flagHeaderAnswerType7 = true;
                var headCommentArr = question.Comment.split(',');
                var idCheckForSubTooltip = 7;

                //Handle DataSeries
                var cate = [];
                var answerNameArr = new Array();
                var dataSeries = [];
                var count = 0;
                if (question.Children[0].AnswerId > 0) { //Chart level 1
                    var dataArr = new Array();
                    count = 0;
                    //Bar
                    for (var i = 0; i < question.Children.length ; i++) {
                        dataArr = new Array();
                        dataArr[0] = question.Children[i].Cal;
                        var obj = {
                            name: question.Children[i].Name, color: colors[i], type: 'column', yAxis: 1, data: dataArr,
                            tooltip: {
                                valueSuffix: ' % ' 
                            }
                        };
                        dataSeries[count] = obj;
                        count++;
                    }
                    //Line
                    for (var i = 0; i < question.Children.length ; i++) {
                        dataArr = new Array();
                        dataArr[0] = question.Children[i].Persion;
                        var obj = {
                            name: question.Children[i].Name, color: colors[i], type: 'spline', data: dataArr,
                            tooltip: {
                                valueSuffix: ' ' + ValidText.TooltipChartPerson 
                            }
                        };
                        dataSeries[count] = obj;
                        count++;
                    }

                    cate[0] = question.Name;
                }
                else if (question.Children[0].Children[0] != null && question.Children[0].Children[0].AnswerId > 0) { //Chart level 2
                    //Get Category
                    for (var i = 0; i < question.Children.length ; i++) {
                        cate[i] = question.Children[i].Name;
                    }

                    //Get answername
                    answerNameArr = new Array();
                    answerSubTooltipArr = new Array();
                    for (var k = 0; k < question.Children[0].Children.length; k++) {
                       
                        //set tooltip for answer with radio type, if header contain character '#@#' and answerType = 7 (radio button)
                        if (flagHeaderAnswerType7 == true && question.Children[0].Children[k].AnswerType == idCheckForSubTooltip)
                            answerSubTooltipArr[k] = assignHeaderWithName(question.Children[0].Children[k].Name, headCommentArr, ' (', ')');
                        else
                            answerSubTooltipArr[k] = '';

                        //set answername
                        answerNameArr[k] = question.Children[0].Children[k].Name;
                    }
                  
                    count = 0;

                    //data for Bar
                    for (var l = 0; l < answerNameArr.length; l++) {
                        dataArr = new Array();

                        for (var n = 0; n < question.Children.length ; n++) {
                            if (typeof question.Children[n].Children[l] != "undefined") {
                                dataArr[n] = question.Children[n].Children[l].Cal;
                            }
                        }
                        var obj = {
                            name: answerNameArr[l], color: colors[l], type: 'column', yAxis: 1, data: dataArr,
                            tooltip: {
                                valueSuffix: ' %' + answerSubTooltipArr[l]
                            }
                        };
                        dataSeries[count] = obj;
                        count++;
                    }

                    //data for Line
                    for (var l = 0; l < answerNameArr.length; l++) {
                        dataArr = new Array();
                        for (var n = 0; n < question.Children.length ; n++) {
                            if (typeof question.Children[n].Children[l] != "undefined")
                                dataArr[n] = question.Children[n].Children[l].Persion;
                        }
                        var obj = {
                            name: answerNameArr[l], color: colors[l], type: 'spline', data: dataArr,
                            tooltip: {
                                valueSuffix: ' ' + ValidText.TooltipChartPerson + answerSubTooltipArr[l]
                            }
                        };
                        dataSeries[count] = obj;
                        count++;
                    }
                }
                else if (question.Children[0].Children[0].Children[0] != null && question.Children[0].Children[0].Children[0].AnswerId > 0) { //Chart level 3
                    //Get answername
                    answerNameArr = new Array();
                    for (var k = 0; k < question.Children[0].Children[0].Children.length; k++) {
                        answerNameArr[k] = question.Children[0].Children[0].Children[k].Name;
                    }

                    //Get Category
                    count = 0;
                    for (var i = 0; i < question.Children.length ; i++) {
                        for (var j = 0; j < question.Children[i].Children.length; j++) {
                            cate[count] = question.Children[i].Name + " - " + question.Children[i].Children[j].Name;
                            count++;
                        }
                    }

                    var countData = 0;
                    count = 0;
                    //Get category and data Bar
                    for (var l = 0; l < answerNameArr.length; l++) {
                        dataArr = new Array();
                        countData = 0;
                        for (var n = 0; n < question.Children.length ; n++) {
                            for (var m = 0; m < question.Children[n].Children.length ; m++) {
                                dataArr[countData] = question.Children[n].Children[m].Children[l].Cal;
                                countData++;
                            }
                        }

                        var obj = {
                            name: answerNameArr[l], color: colors[l], type: 'column', yAxis: 1, data: dataArr,
                            tooltip: {
                                valueSuffix: ' %'
                            }
                        };
                        dataSeries[count] = obj;
                        count++;
                    }

                    for (var l = 0; l < answerNameArr.length; l++) {
                        dataArr = new Array();
                        countData = 0;
                        for (var n = 0; n < question.Children.length ; n++) {
                            for (var m = 0; m < question.Children[n].Children.length ; m++) {
                                dataArr[countData] = question.Children[n].Children[m].Children[l].Persion;
                                countData++;
                            }

                        }

                        var obj = {
                            name: answerNameArr[l], color: colors[l], type: 'spline', data: dataArr,
                            tooltip: {
                                valuesuffix: ' ' + ValidText.TooltipChartPerson
                            }
                        };
                        dataSeries[count] = obj;
                        count++;

                    }

                }

                writeBarAndLineChart(title, subTitle, cate, dataSeries, subTitleDate);

            };

            function writeBarAndLineChart(title, subTitle, cate, dataSeries, subTitleDate) {
                var subTitleWithoutDate = subTitle + "<br><span>" + ValidText.SubTextNoteBL + "</span>";
                $('#barAndLineChart').highcharts({
                    chart: {
                        zoomType: 'xy'
                    },
                    title: {
                        text: title
                    },
                    subtitle: {
                        text: subTitleDate == " / " ? subTitleWithoutDate : (ValidText.GerneralTextDate + " : " + subTitleDate + "<br>") + subTitleWithoutDate
                    },
                    xAxis: [{
                        categories: cate
                    }],
                    yAxis: [{ // Primary yAxis - Person
                        labels:
                        {
                            format: '{value} ' + ValidText.TooltipChartPerson,
                            style: {
                                color: '#89A54E'
                            }
                        },
                        title: {
                            text: ValidText.BarChartPersonRank,
                            style: {
                                color: '#89A54E'
                            }
                        },
                        min: 0,
                        startOnTick: true
                    }, { // Secondary yAxis - Bar
                        title: {
                            text: ValidText.BarChartPercentRank,
                            style: {
                                color: '#4572A7'
                            }
                        },
                        labels: {
                            format: '{value} %',
                            style: {
                                color: '#4572A7'
                            }
                        },
                        opposite: true,
                        min: 0,
                        startOnTick: true
                    }],
                    tooltip: {
                        shared: true
                    },
                    //legend: {
                    //    layout: 'vertical',
                    //    align: 'left',
                    //    x: 120,
                    //    verticalAlign: 'top',
                    //    y: 100,
                    //    floating: true,
                    //    backgroundColor: '#FFFFFF'
                    //},
                    series: dataSeries,
                    exporting: {
                        buttons: {
                            contextButton: {

                                menuItems: [
                                    { text: ValidText.ContextMenuPrintChart, textKey: "printChart", onclick: function () { this.print() } }, { separator: !0 },
                                    { text: ValidText.ContextMenuPNG, textKey: "downloadPNG", onclick: function () { this.exportChart() } },
                                    { text: ValidText.ContextMenuJPEG, textKey: "downloadJPEG", onclick: function () { this.exportChart({ type: "image/jpeg" }) } },
                                    { text: ValidText.ContextMenuPDF, textKey: "downloadPDF", onclick: function () { this.exportChart({ type: "application/pdf" }) } },
                                    { text: ValidText.ContextMenuSVG, textKey: "downloadSVG", onclick: function () { this.exportChart({ type: "image/svg+xml" }) } }
                                ]
                            }
                        },
                        sourceWidth: 1000,
                        sourceHeight: 600
                    }
                });

            }

            $scope.dateLineChartFlag = true;    //This field prevent duplicate event dateLineChart
            $scope.dateLineChart = function () {
                if (!$scope.dateLineChartFlag) return;
                $scope.dateLineChartFlag = false;
                
                $modalLineChart.modal('show');

                var dateFrom = $scope.searchParams.DateFrom;
                var dateTo = $scope.searchParams.DateTo;
                var surveyId = $scope.editingSurvey.Id;
                var subTitleDate = "";

                var strQuery = "";
                if (surveyId != undefined && surveyId != '')
                    strQuery += "surveyId=" + surveyId;
                else
                    strQuery += "surveyId=0";

                if (dateFrom != undefined && dateFrom != '') {
                    strQuery += "&dateFrom=" + parseDateToString(dateFrom);
                    subTitleDate += parseDateToString2(dateFrom) + " / ";
                } else {
                    strQuery += "&dateFrom=";
                    subTitleDate = " / ";
                }

                if (dateTo != undefined && dateTo != '') {
                    strQuery += "&dateTo=" + parseDateToString(dateTo);
                    subTitleDate += parseDateToString2(dateTo);
                } else
                    strQuery += "&dateTo=";

                strQuery += "&langId=" + $attrs.langid;

                $http.get(APP_ROOT + "api/SurveyDateLineChart/GetListLineChart?" + strQuery)
                        .success(function (data) {
                            if (data != null && data != '') {
                                $("#lineChart").css("display", "block");
                                handleDataLineChart(data, subTitleDate);
                            } else {
                                $('#lineChart').css("display", "none");
                            }
                            $scope.dateLineChartFlag = true;
                        }).error(function (data) {
                            $scope.dateLineChartFlag = true;
                            console.log('fail');
                        });

            };

            function handleDataLineChart(data, subTitleDate) {
                var title = $scope.editingSurvey.SurveyName; //+ " - " + parseDateToStringFormat2($scope.editingSurvey.DateCreated);
                var subTitle = ValidText.GerneralTextDate + ": " + subTitleDate;
                var cate = [];
                var dataSeries = [];

                for (var i = 0; i < data.length; i++) {
                    cate[i] = parseDateToDateMonthFormat(data[i].StartDate) + "|";
                    dataSeries[i] = data[i].PersonCount;

                }

                writeDateLineChart(title, subTitle, cate, dataSeries);
            }

            function writeDateLineChart(title, subTitle, cate, dataSeries) {
                $('#lineChart').highcharts({
                    chart: {
                        type: 'line'
                    },
                    title: {
                        text: title
                    },
                    subtitle: {
                        text: subTitle
                    },
                    xAxis: {
                        categories: cate
                        , labels: {
                            staggerLines: 1
                        }
                    },
                    yAxis: {
                        title: {
                            text: ValidText.BarChartPersonRank
                        },
                        startOnTick: false
                    },
                    tooltip: {
                        enabled: true,
                        formatter: function () {
                            return this.x.substring(0, this.x.length - 1) + ' : ' + '<b>' + this.y + '</b>';
                        }
                    },
                    plotOptions: {
                        line: {
                            dataLabels: {
                                enabled: true
                            },
                            enableMouseTracking: true
                        }
                    },
                    series:
                    [{
                        name: title,
                        data: dataSeries
                    }]
                    ,
                    exporting: {
                        buttons: {
                            contextButton: {

                                menuItems: [
                                    { text: ValidText.ContextMenuPrintChart, textKey: "printChart", onclick: function () { this.print() } }, { separator: !0 },
                                    { text: ValidText.ContextMenuPNG, textKey: "downloadPNG", onclick: function () { this.exportChart() } },
                                    { text: ValidText.ContextMenuJPEG, textKey: "downloadJPEG", onclick: function () { this.exportChart({ type: "image/jpeg" }) } },
                                    { text: ValidText.ContextMenuPDF, textKey: "downloadPDF", onclick: function () { this.exportChart({ type: "application/pdf" }) } },
                                    { text: ValidText.ContextMenuSVG, textKey: "downloadSVG", onclick: function () { this.exportChart({ type: "image/svg+xml" }) } }
                                ]
                            }
                        },
                        sourceWidth: 1000,
                        sourceHeight: 600
                    }
                });
            }

            $scope.stackChart = function (question, isPercent) {
                var title = $scope.editingSurvey.SurveyName; 
                var subTitle = question.Name;
                var cate = [];
                var dataSeries = [];
                var subTitleDate = getSubTitleDate();
                
                //Handle to add more for the HighChart color 
                var colors = Highcharts.getOptions().colors;
                var maxColorLengh = colors.length - 1;
                var subColors = ['#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4', '#EAEAEA', '#666999', '#006699'];
                for (var k = 0; k < subColors.length; k++) {
                    colors[maxColorLengh + k] = subColors[k];
                }

                //Header Answer
                var flagHeaderAnswerType7 = false;
                if (typeof question.HeaderAnswer != "undefined" && question.HeaderAnswer.indexOf('#@#') > 0)
                    flagHeaderAnswerType7 = true;
                var headCommentArr = question.Comment.split(',');
                var idCheckForSubTooltip = 7;

                if (question.Children[0].AnswerId > 0) {                                //Chart level 1

                    for (var i = 0; i < question.Children.length ; i++) {
                        var dataArr = new Array();
                        dataArr[0] = isPercent == 1 ? question.Children[i].Cal : question.Children[i].Persion;
                        var obj = { name: question.Children[i].Name, data: dataArr };
                        dataSeries[i] = obj;
                    }
                    cate[0] = question.Name;
                }
                else if (question.Children[0].Children[0] != null && question.Children[0].Children[0].AnswerId > 0) {               //Chart level 2

                    //Get Category
                    for (var i = 0; i < question.Children.length ; i++) {
                        cate[i] = question.Children[i].Name;
                    }

                    //Get answername
                    var answerNameArr = new Array();
                    for (var k = 0; k < question.Children[0].Children.length; k++) {
                        if (flagHeaderAnswerType7 == true && question.Children[0].Children[k].AnswerType == idCheckForSubTooltip)
                            answerNameArr[k] = assignHeaderWithName(question.Children[0].Children[k].Name, headCommentArr, '', '');
                        else
                            answerNameArr[k] = question.Children[0].Children[k].Name;
                    }

                    //Get category and data
                    for (var l = 0; l < answerNameArr.length; l++) {
                        var dataArr = new Array();
                        for (var n = 0; n < question.Children.length ; n++) {
                            if (typeof question.Children[n].Children[l] != "undefined")
                                dataArr[n] = isPercent == 1 ? question.Children[n].Children[l].Cal : question.Children[n].Children[l].Persion;
                        }

                        dataSeries[l] = { name: answerNameArr[l], data: dataArr };
                    }
                }
                else if (question.Children[0].Children[0].Children[0] != null && question.Children[0].Children[0].Children[0].AnswerId > 0) {               //Chart level 3
                    //Get answername
                    var answerNameArr = new Array();
                    for (var k = 0; k < question.Children[0].Children[0].Children.length; k++) {
                        answerNameArr[k] = question.Children[0].Children[0].Children[k].Name;
                    }

                    //Get Category
                    var count = 0;
                    for (var i = 0; i < question.Children.length ; i++) {
                        for (var j = 0; j < question.Children[i].Children.length; j++) {
                            cate[count] = question.Children[i].Name + " - " + question.Children[i].Children[j].Name;
                            count++;
                        }
                    }

                    //Get category and data
                    for (var l = 0; l < answerNameArr.length; l++) {
                        var count = 0;
                        var dataArr = new Array();

                        for (var n = 0; n < question.Children.length ; n++) {
                            for (var m = 0; m < question.Children[n].Children.length ; m++) {
                                dataArr[count] = isPercent == 1 ? question.Children[n].Children[m].Children[l].Cal : question.Children[n].Children[m].Children[l].Persion;
                                count++;
                            }
                        }

                        dataSeries[l] = { name: answerNameArr[l], data: dataArr };
                    }

                }

                //write Bar Chart
                var yText = isPercent == 1 ? ValidText.BarChartPercentRank : ValidText.BarChartPersonRank;
                var tooltipText = isPercent == 1 ? '%' : ValidText.TooltipChartPerson;
               
                writeStackChart(title, subTitle, cate, dataSeries, yText, tooltipText, subTitleDate);
            };
            
            function writeStackChart(title, subTitle, cate, dataSeries, yText, tooltipText, subTitleDate) {
                $('#stackChart').highcharts({
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: title
                    },
                    subtitle: {
                        text: subTitleDate == " / " ? subTitle : (ValidText.GerneralTextDate + " : " + subTitleDate + "<br>") + subTitle
                    },
                    xAxis: {
                        categories: cate
                    },
                    yAxis: {
                        min: 0,
                        title: {
                            text: yText
                        }
                    },
                    tooltip: {
                        pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
                        shared: true
                    },
                    plotOptions: {
                        column: {
                            stacking: 'percent'
                        }
                    },
                    series: dataSeries,
                    exporting: {
                        buttons: {
                            contextButton: {

                                menuItems: [
                                    { text: ValidText.ContextMenuPrintChart, textKey: "printChart", onclick: function () { this.print() } }, { separator: !0 },
                                    { text: ValidText.ContextMenuPNG, textKey: "downloadPNG", onclick: function () { this.exportChart() } },
                                    { text: ValidText.ContextMenuJPEG, textKey: "downloadJPEG", onclick: function () { this.exportChart({ type: "image/jpeg" }) } },
                                    { text: ValidText.ContextMenuPDF, textKey: "downloadPDF", onclick: function () { this.exportChart({ type: "application/pdf" }) } },
                                    { text: ValidText.ContextMenuSVG, textKey: "downloadSVG", onclick: function () { this.exportChart({ type: "image/svg+xml" }) } }
                                ]
                            }
                        },
                        sourceWidth: 1000,
                        sourceHeight: 600
                    }
                });
            }

            function refreshChart(id) {
                $(".insChart").each(function () {
                    $(this).css("display", "none");
                });

                $("#" + id).empty();
                $("#" + id).css("display", "block");

                if ($scope.chartType == 3) {
                    $("#colWithChartType").css("display", "none");
                } else {
                    $("#colWithChartType").css("display", "block");
                }

            }

            function getSubTitleDate() {
                var dateFrom = $scope.searchParams.DateFrom;
                var dateTo = $scope.searchParams.DateTo;
                var subTitleDate = "";

                if (dateFrom != undefined && dateFrom != '') {
                    subTitleDate += parseDateToString2(dateFrom) + " / ";
                } else {
                    subTitleDate = " / ";
                }

                if (dateTo != undefined && dateTo != '') {
                    subTitleDate += parseDateToString2(dateTo);
                }

                return subTitleDate;
            }

            function assignHeaderWithName(name, headCommentArr, prefix, subfix) {
                var nameNumber = parseInt(name);
                if (!isNaN(nameNumber) && nameNumber > 0) {
                    return prefix + headCommentArr[nameNumber - 1] + subfix;
                }

                return '';
            }
            //-------------------------------------------------------------------------------Paging, Sorting, Filtering
            $scope.pageSize = config.pageSize;

            $scope.sortingOrder = {
                'listSurveyResults': 's.SURVEY_Base_Survey_id'
            };
            $scope.reverse = {
                'listSurveyResults': true
            };

            $scope.isFilter = {
                'listSurveyResults': false
            };

            $scope.sign = {
                'listSurveyResults': "+"
            };

            $scope.query = {
                'listSurveyResults': null
            };

            $scope.$on("pageIndexChanged", function (event, pageIndex) {
                if (event.targetScope.identifier == "pagingCustomerCard") {
                    $scope.getListCustomerCard(pageIndex);
                }

            });

            $scope.toggleFilter = function (listname) {
                $scope.isFilter[listname] = !$scope.isFilter[listname];
                $scope.sign[listname] = ($scope.isFilter[listname]) ? "-" : "+";

                if ($scope.isFilter[listname] == false) {
                    $scope.query[listname] = undefined;
                }
            };

            $scope.sort_by = function (newSortingOrder, listname) {
                if ($scope.sortingOrder[listname] == '') {
                    $scope.sortingOrder[listname] = newSortingOrder;
                }

                if ($scope.sortingOrder[listname] == newSortingOrder) {
                    $scope.reverse[listname] = !$scope.reverse[listname];
                }

                $scope.sortingOrder[listname] = newSortingOrder;

                $('th span.tablesort').each(function () {
                    $(this).removeClass('sortasc').removeClass('sortdesc');
                });

                if ($scope.reverse[listname])
                    $('th.' + newSortingOrder + ' span').addClass('sortdesc');
                else
                    $('th.' + newSortingOrder + ' span').addClass('sortasc');

                if (listname == 'listSurveyResults')
                    $scope.getListBaseSurvey(0);

            };

            $scope.searchBaseSurvey = function () {
                $scope.getListBaseSurvey(0);
            };

            //--------------------------------------------------------------------------------Call GetList
            $scope.getListBaseSurvey(0);

        }]
    };
});


