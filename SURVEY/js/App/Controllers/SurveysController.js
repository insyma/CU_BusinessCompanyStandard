function SurveysController($scope, languageId, $modal, $q, $filter, config, $sce,
                            SurveysResource, SurveyStructuresResource, QuestionsResource,
                            AnswersResource, AnswerValuesResource, QuestionTypesResource, surveyResourcesAlt) {
    $scope.ANSWER_TYPE = {
        DROP_DOWN: 8
    };

    $scope.QUESTION_TYPE = {
        FORM: 6
    };

    $scope.DEPENDENCY_TYPE = {
        DEPENDENCY_GROUP: 1,
        DEPENDENCY: 2
    };

    // $scope.structure.Images = [];

    $scope.isstructuretext = false;


    var answersPageSize = 10; //use a different value than the default
    var answerValuesPageSize = 10; //use a different value than the default

    $scope.Surveys = SurveysResource.LoadSurvey({ languageId: languageId });

    $scope.selectedSurvey = null;

    function RefreshAllAnswer(Question, AnswerId, AnswerName, AnswerTypeId, AnswerTypeName, Value) {
        if (Question.Answers) {

            for (var i = 0; i < Question.Answers.length; i++) {
                var answer = Question.Answers[i];
                if (answer.Id == AnswerId) {
                    answer.AnswerName = AnswerName;
                    answer.AnswerTypeId = AnswerTypeId;
                    answer.AnswerTypeName = AnswerTypeName;
                    answer.Value = Value;
                }
            }
        }

        if (Question.Questions) {
            for (var j = 0; j < Question.Questions.length; j++) {
                RefreshAllAnswer(Question.Questions[j], AnswerId, AnswerName, AnswerTypeId, AnswerTypeName, Value);
            }
        }
    };

    function FindSubQuestionById(Question, subQuestionId) {
        var question = null;
        if (Question.Questions) {
            for (var i = 0; i < Question.Questions.length; i++) {
                if (Question.Questions[i].Id == subQuestionId) {
                    return { question: Question.Questions[i], parentQuestion: Question };
                }
                else {
                    question = FindSubQuestionById(Question.Questions[i], subQuestionId);
                    if (question)
                        return question;
                }
            }
        }

        return question;
    };

    $scope.selectSurvey = function (survey) {
        SurveyStructuresResource.GetBySurveyId({
            surveyId: survey.Id,
            languageId: languageId
        }, function (Structures) {
            $scope.selectedSurvey = survey;
            $scope.selectedSurvey.Structures = Structures;

            $scope.selectedSurvey.RefreshAllAnswer = function (AnswerId, AnswerName, AnswerTypeId, AnswerTypeName, Value) {
                for (var i = 0; i < this.Structures.length; i++) {
                    if (this.Structures[i].Questions) {
                        for (var j = 0; j < this.Structures[i].Questions.length; j++) {
                            RefreshAllAnswer(this.Structures[i].Questions[j], AnswerId, AnswerName, AnswerTypeId, AnswerTypeName, Value);
                        }
                    }
                }
            };

            $scope.selectedSurvey.findQuestionById = function (questionId) {
                var question = null;
                for (var i = 0; i < this.Structures.length; i++) {
                    if (this.Structures[i].Questions) {
                        for (var j = 0; j < this.Structures[i].Questions.length; j++) {
                            if (this.Structures[i].Questions[j].Id == questionId) {
                                return { question: this.Structures[i].Questions[j], structure: this.Structures[i] };
                            }
                            else {
                                question = FindSubQuestionById(this.Structures[i].Questions[j], questionId);
                                if (question)
                                    return question;
                            }
                        }
                    }
                }

                return question;
            };

            $scope.selectedSurvey.findStructureById = function (structureId) {
                for (var i = 0; i < this.Structures.length; i++) {
                    if (this.Structures[i].Id == structureId) {
                        return this.Structures[i];
                    }
                }
                return null;
            };

        }, function () {
            //error
        });
    };

    $scope.addSurvey = function () {
        $scope.editSurvey({});
    };

    $scope.editSurvey = function (survey) {
        var scope = $scope.$new();
        scope.survey = { Id: survey.Id, SurveyName: survey.SurveyName, TemplatePath: survey.TemplatePath };

        var modalPromise = $modal({ template: 'surveyPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
        });
    };

    $scope.updateSurvey = function (survey, dismiss) {
        if (!survey.SurveyName || !survey.TemplatePath)
            return;

        var postData = {
            SurveyName: survey.SurveyName,
            TemplatePath: survey.TemplatePath
        };

        if (survey.Id > 0) { //Update

            SurveysResource.UpdateSurvey({ id: survey.Id, languageId: languageId }, postData, function (newSurvey) {
                $scope.selectedSurvey.SurveyName = survey.SurveyName;
                $scope.selectedSurvey.TemplatePath = survey.TemplatePath;
                dismiss();
            }, function () {
                //error
            });
        }
        else {//Insert

            SurveysResource.InsertSurvey({ languageId: languageId }, postData, function (newSurvey) {
                survey.Id = newSurvey.Id;
                survey.CreatedDate = newSurvey.CreatedDate;

                $scope.Surveys.push(survey);

                dismiss();
            }, function () {
                //error
            });
        }
    };

    $scope.deleteSurvey = function () {
        if ($scope.selectedSurvey) {

            var scope = $scope.$new();
            scope.confirm = function () {

                //Use bracket notation syntax to avoid error in IE (conflict with delete keyword in IE)
                SurveysResource.DeleteSurvey({
                    id: $scope.selectedSurvey.Id
                }, function () {
                    $scope.Surveys.splice($scope.Surveys.indexOf($scope.selectedSurvey), 1);
                    $scope.backtoList();

                    scope.dismiss();
                }, function () {
                });
            }

            var modalPromise = $modal({ template: 'confirmationDialog.html', persist: true, show: false, backdrop: 'static', scope: scope });
            $q.when(modalPromise).then(function (modalEl) {
                modalEl.modal('show');
            });
        }
    };

    $scope.publishSurvey = function (survey) {

        surveyResourcesAlt.PublishSurvey({
            surveyId: survey.Id
        }, null, function () {
            alert("Publish finished");
        }, function (err) {

            console.log("Publish is not finished. Error :" + err);
        });
    };

    $scope.expandStructure = function (Structure) {
        if (Structure.isExpanded) {
            Structure.isExpanded = !Structure.isExpanded;
        }
        else {
            QuestionsResource.GetByStructureId({
                languageId: languageId,
                structureId: Structure.Id
            }, function (questions) {
                Structure.Questions = questions;

                Structure.isExpanded = !Structure.isExpanded;
            }, function () {
                //error
            });
        }
    };

    $scope.expandQuestion = function (Question) {
        if (Question.isExpanded) {
            Question.isExpanded = !Question.isExpanded;
        }
        else {
            QuestionsResource.GetByParentId({
                languageId: languageId,
                parentId: Question.Id
            }, function (data) {
                Question.Questions = data.questions;
                Question.Answers = data.answers;

                Question.isExpanded = !Question.isExpanded;
            }, function () {
                //error
            });
        }
    };

    $scope.addSurveyStructure = function (selectedSurvey) {

        $scope.isstructuretext = false;
        $scope.editSurveyStructure({ surveyId: selectedSurvey.Id });
    };

    $scope.editSurveyStructure = function (structure) {
        $scope.selectedStructure = structure;

        var scope = $scope.$new();
        scope.structure = {
            Id: structure.Id,
            StructureName: structure.StructureName,
            surveyId: structure.surveyId,
            TemplatePath: structure.TemplatePath,
            ImageFolderPath: structure.ImageFolderPath
        };

        if (structure.Id > 0) {

            $scope.isstructuretext = true;
            SurveyStructuresResource.LoadStructureTextsAndImages({
                structureId: structure.Id,
                languageId: languageId
            }, function (data) {
                scope.structure.Texts = data.Texts;

                angular.forEach(scope.structure.Texts, function (text) {
                    text.Value = $sce.trustAsHtml(text.Value);
                });

                scope.structure.Images = data.Images;

                var modalPromise = $modal({ template: 'surveyStructurePopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
                $q.when(modalPromise).then(function (modalEl) {
                    modalEl.modal('show');
                });
            });
        }
        else {
            var modalPromise = $modal({ template: 'surveyStructurePopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
            $q.when(modalPromise).then(function (modalEl) {
                modalEl.modal('show');
            });
        }
    };

    $scope.updateSurveyStructure = function (structure, dismiss) {
        if (!structure.StructureName || !structure.TemplatePath || !structure.ImageFolderPath)
            return;

        $scope.isstructuretext = true;

        var postData = {
            StructureName: structure.StructureName,
            surveyId: structure.surveyId,
            TemplatePath: structure.TemplatePath,
            ImageFolderPath: structure.ImageFolderPath
        };

        if (structure.Id > 0) { //Update
            SurveyStructuresResource.UpdateSurveyStructure({ id: structure.Id, languageId: languageId }, postData, function () {
                $scope.selectedStructure.StructureName = structure.StructureName;
                $scope.selectedStructure.TemplatePath = structure.TemplatePath;
                $scope.selectedStructure.ImageFolderPath = structure.ImageFolderPath;

                dismiss();
            }, function () {
                //error
            });
        }
        else { //Insert
            SurveyStructuresResource.InsertSurveyStructure({ languageId: languageId }, postData, function (newStructure) {
                structure.Id = newStructure.Id;

                var lastStructure = $scope.selectedSurvey.Structures.last();
                structure.Position = lastStructure ? lastStructure.Position + 1 : 1;

                $scope.selectedSurvey.Structures.push(structure);

                // dismiss();
            }, function () {
                //error
            });
        }
    };

    $scope.editSurveyDependencyGroup = function (dependencyGroup) {
        this.editingDependencyGroup = {
            Id: dependencyGroup.Id,
            GroupTypeId: dependencyGroup.GroupTypeId,
            DependencyType: dependencyGroup.DependencyType,
            Children: dependencyGroup.Children
        };
    };

    $scope.cancelEditSurveyDependencyGroup = function () {
        if (this.dependencyGroup.Id) { //Update
            this.editingDependencyGroup = null;
        } else {//Add new => remove if it's not root
            if (this.dependencyGroup.parent) {
                var itemIndex = this.dependencyGroup.parent.Children.indexOf(this.dependencyGroup);
                this.dependencyGroup.parent.Children.splice(itemIndex, 1);
            }
        }
    };

    $scope.editSurveyDependency = function (dependency) {
        this.editingDependency = {
            Id: dependency.Id,
            SurveyQuestionId: dependency.SurveyQuestionId,
            SurveyAnswerId: dependency.SurveyAnswerId,
            DependencyType: dependency.DependencyType
        };
    };

    $scope.cancelEditSurveyDependency = function () {
        if (this.dependency.Id) { //Update
            this.editingDependency = null;
        } else { //Add new => remove 
            var itemIndex = this.dependency.parent.Children.indexOf(this.dependency);
            this.dependency.parent.Children.splice(itemIndex, 1);
        }
    };

    $scope.addSurveyDependency = function (parentDependencyGroup) {
        var newDependency = {
            parent: parentDependencyGroup,
            DependencyType: $scope.DEPENDENCY_TYPE.DEPENDENCY
        };

        parentDependencyGroup.Children = parentDependencyGroup.Children || [];
        parentDependencyGroup.Children.push(newDependency);

        this.editSurveyDependency(newDependency);
    };

    $scope.addSurveyDependencyGroup = function (parentDependencyGroup) {
        var newDependencyGroup = {
            parent: parentDependencyGroup,
            DependencyType: $scope.DEPENDENCY_TYPE.DEPENDENCY_GROUP
        };

        parentDependencyGroup.Children = parentDependencyGroup.Children || [];
        parentDependencyGroup.Children.push(newDependencyGroup);

        this.editSurveyDependencyGroup(newDependencyGroup);
    };

    $scope.deleteSurveyDependencyGroup = function (dependencyGroup, parent) {
        SurveysResource.DeleteDependencyGroup({
            id: dependencyGroup.Id
        }, function () {

            if (parent) {
                var itemIndex = parent.Children.indexOf(dependencyGroup);
                parent.Children.splice(itemIndex, 1);
            }
            else { //delete root node
                var structure = this.dependencyGroup.structure;
                var question = this.dependencyGroup.question;

                this.dependencyGroup = {
                    structure: structure,
                    question: question
                };

                this.editSurveyDependencyGroup(this.dependencyGroup);
            }
        } .bind(this));
    };

    $scope.deleteSurveyDependency = function (dependency, parent) {
        SurveysResource.DeleteDependency({
            id: dependency.Id
        }, function () {
            var itemIndex = parent.Children.indexOf(dependency);
            parent.Children.splice(itemIndex, 1);
        });
    };

    $scope.updateSurveyDependencyGroup = function () {
        //Perform validation
        if (!this.editingDependencyGroup.GroupTypeId) {
            return;
        }

        if (this.dependencyGroup.Id > 0) { //Update

            SurveysResource.UpdateDependencyGroup({
                id: this.dependencyGroup.Id
            }, {
                GroupTypeId: this.editingDependencyGroup.GroupTypeId
            }, function () {
                angular.copy(this.editingDependencyGroup, this.dependencyGroup);
                this.cancelEditSurveyDependencyGroup();
            } .bind(this));

        } else { //Add new group

            var def = $q.defer();

            if (this.dependencyGroup.structure) {//add root group for structure
                SurveyStructuresResource.CreateRootDependencyGroup({
                    structureId: this.dependencyGroup.structure.Id
                }, {
                    GroupTypeId: this.editingDependencyGroup.GroupTypeId
                }, function (data) {
                    def.resolve(data);
                });
            }
            else if (this.dependencyGroup.question) {//add root group for question
                QuestionsResource.CreateRootDependencyGroup({
                    questionId: this.dependencyGroup.question.Id
                }, {
                    GroupTypeId: this.editingDependencyGroup.GroupTypeId
                }, function (data) {
                    def.resolve(data);
                });
            }
            else if (this.dependencyGroup.parent) {//Add child group
                SurveysResource.CreateDependencyGroup({}, {
                    ParentId: this.dependencyGroup.parent.Id,
                    GroupTypeId: this.editingDependencyGroup.GroupTypeId
                }, function (data) {
                    def.resolve(data);
                });
            }

            if (def.promise) {
                def.promise.then(function (newGroup) {
                    this.dependencyGroup.GroupTypeId = this.editingDependencyGroup.GroupTypeId;
                    this.dependencyGroup.DependencyType = $scope.DEPENDENCY_TYPE.DEPENDENCY_GROUP;

                    this.dependencyGroup.Id = newGroup.Id;

                    this.cancelEditSurveyDependencyGroup();
                } .bind(this));
            }
        }
    };

    $scope.updateSurveyDependency = function () {
        //perform validation
        if (!this.editingDependency.SurveyQuestionId || !this.editingDependency.SurveyAnswerId) {
            return;
        }

        if (this.dependency.Id) { //Update
            SurveysResource.UpdateDependency({
                id: this.dependency.Id
            }, {
                SurveyQuestionId: this.editingDependency.SurveyQuestionId,
                SurveyAnswerId: this.editingDependency.SurveyAnswerId
            }, function () {
                angular.copy(this.editingDependency, this.dependency);
                this.cancelEditSurveyDependency();
            } .bind(this));
        }
        else {//Add new
            SurveysResource.AddNewDependency({}, {
                ParentId: this.dependency.parent.Id,
                SurveyQuestionId: this.editingDependency.SurveyQuestionId,
                SurveyAnswerId: this.editingDependency.SurveyAnswerId
            }, function (newDependency) {
                angular.copy(this.editingDependency, this.dependency);

                this.dependency.Id = newDependency.Id;

                this.cancelEditSurveyDependency();
            } .bind(this));
        }
    };

    $scope.loadDropdownDataForDependenciesConfiguration = function (scope) {
        if (!$scope.GroupTypes) {
            SurveysResource.LoadDependencyGroupTypes({}, function (data) {
                $scope.GroupTypes = data;
            });
        }

        QuestionsResource.GetAllRootQuestions({
            surveyId: $scope.selectedSurvey.Id,
            languageId: languageId
        }, function (data) {
            scope.Questions = data;
        });

    };

    $scope.editSurveyQuestionDependencies = function (question) {
        var scope = $scope.$new();

        $scope.loadDropdownDataForDependenciesConfiguration(scope);

        QuestionsResource.LoadDependencies({
            questionId: question.Id
        }, function (data) {
            scope.rootDependencyGroup = data;

            scope.rootDependencyGroup.question = question;

            if (!scope.rootDependencyGroup.Id) {
                scope.editSurveyDependencyGroup(scope.rootDependencyGroup);
            }

            var modalPromise = $modal({ template: 'dependenciesPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
            $q.when(modalPromise).then(function (modalEl) {
                modalEl.modal('show');
            });
        });
    };

    $scope.editSurveyStructureDependencies = function (structure) {
        var scope = $scope.$new();

        $scope.loadDropdownDataForDependenciesConfiguration(scope);

        SurveyStructuresResource.LoadDependencies({
            structureId: structure.Id
        }, function (data) {
            scope.rootDependencyGroup = data;

            scope.rootDependencyGroup.structure = structure;

            if (!scope.rootDependencyGroup.Id) {
                scope.editSurveyDependencyGroup(scope.rootDependencyGroup);
            }

            var modalPromise = $modal({ template: 'dependenciesPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
            $q.when(modalPromise).then(function (modalEl) {
                modalEl.modal('show');
            });
        });
    };

    $scope.deleteSurveyStructure = function (structure) {
        var scope = $scope.$new();

        scope.confirm = function () {

            SurveyStructuresResource.DeleteSurveyStructure({
                id: structure.Id
            }, function () {
                $scope.selectedSurvey.Structures.splice($scope.selectedSurvey.Structures.indexOf(structure), 1);

                scope.dismiss();
            }, function () {

            });
        }

        var modalPromise = $modal({ template: 'confirmationDialog.html', persist: true, show: false, backdrop: 'static', scope: scope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
        });
    };

    $scope.addStructureQuestion = function (structure) {
        //$scope.selectedStructure = structure;
        $scope.editSurveyQuestion({
            structure: structure
        });
    };

    $scope.addSubQuestion = function (question) {
        $scope.editSurveyQuestion({
            parentQuestion: question
        });
    };

    $scope.editSurveyQuestionContactMapping = function (question) {
        var scope = $scope.$new();

        QuestionsResource.LoadQuestionContactMapping({
            questionId: question.Id,
            languageId: languageId
        }, function (data) {
            scope.contactField = data;
            scope.question = question;

            var modalPromise = $modal({ template: 'questionContactFieldPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
            $q.when(modalPromise).then(function (modalEl) {
                modalEl.modal('show');
            });
        });
    };

    $scope.editSurveyQuestionAnswerContactMapping = function (question, answer) {
        var scope = $scope.$new();

        QuestionsResource.LoadQuestionAnswerContactMapping({
            questionId: question.Id,
            answerId: answer.Id,
            languageId: languageId
        }, function (data) {
            scope.contactField = data;
            scope.question = question;
            scope.answer = answer;

            var modalPromise = $modal({ template: 'answerContactFieldPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
            $q.when(modalPromise).then(function (modalEl) {
                modalEl.modal('show');
            });
        });
    };

    $scope.saveQuestionContactField = function (contactField, question) {
        QuestionsResource.SaveQuestionContactMapping({
            questionId: question.Id,
            languageId: languageId
        }, contactField, function () {
            this.dismiss();
        } .bind(this));
    };

    $scope.saveAnswerContactField = function (contactField, question, answer) {
        QuestionsResource.SaveQuestionAnswerContactMapping({
            questionId: question.Id,
            answerId: answer.Id,
            languageId: languageId
        }, contactField, function () {
            this.dismiss();
        } .bind(this));
    };

    $scope.updateSurveyQuestion = function (question, dismiss) {
        if (!question.QuestionName)
            return;

        var postData = {
            QuestionName: question.QuestionName,
            Comment: question.Comment,
            Header: question.Header,
            CalculateAnswerAverage: question.CalculateAnswerAverage,
            IsContactInfo: question.IsContactInfo,
            QuestionTypeId: question.QuestionTypeId,
            structureId: question.structure ? question.structure.Id : null,
            parentId: question.parentQuestion ? question.parentQuestion.Id : null
        };
        if (question.Id > 0) { //Update
            QuestionsResource.UpdateQuestion({
                id: question.Id,
                languageId: languageId
            }, postData, function () {
                $scope.selectedQuestion.QuestionName = question.QuestionName;
                $scope.selectedQuestion.Comment = question.Comment;
                $scope.selectedQuestion.Header = question.Header;
                $scope.selectedQuestion.CalculateAnswerAverage = question.CalculateAnswerAverage;
                $scope.selectedQuestion.IsContactInfo = question.IsContactInfo;
                $scope.selectedQuestion.QuestionTypeId = question.QuestionTypeId;

                dismiss();
            }, function () {
                //error
            });
        }
        else { //Insert
            QuestionsResource.InsertQuestion({
                languageId: languageId
            }, postData, function (newQuestion) {
                question.Id = newQuestion.Id;
                var lastQuestion;

                if (question.structure) {
                    if (question.structure.isExpanded) {
                        lastQuestion = question.structure.Questions.last();
                        question.Position = lastQuestion ? lastQuestion.Position + 1 : 1;
                        question.structure.Questions.push(question);
                    }
                    else {
                        $scope.expandStructure(question.structure);
                    }
                }

                if (question.parentQuestion) {
                    if (question.parentQuestion.isExpanded) {
                        lastQuestion = question.parentQuestion.Questions.last();
                        question.Position = lastQuestion ? lastQuestion.Position + 1 : 1;
                        question.parentQuestion.Questions.push(question);
                    } else {
                        $scope.expandQuestion(question.parentQuestion);
                    }
                }

                dismiss();
            }, function () {
                //error
            });
        }
    };

    $scope.editAnswerValue = function (answerValue) {
        $scope.selectedAnswerValue = answerValue;
        $scope.editingAnswerValue = angular.copy(answerValue);
    };



    $scope.addAnswerValue = function (answer) {
        $scope.editAnswerValue({ answer: answer });
    };

    $scope.reorderQuestionToStructure = function (QuestionId, newPosition, isDown, newStructureId) {
        if ($scope.selectedSurvey) {
            var reorderedQuestion = $scope.selectedSurvey.findQuestionById(QuestionId);

            if (reorderedQuestion.structure && reorderedQuestion.structure.Id == newStructureId) {//order in the same parent
                newPosition = calculateNewPosition(reorderedQuestion.question.Position, newPosition, isDown);

                QuestionsResource.ReorderQuestionPosition({
                    questionId: reorderedQuestion.question.Id,
                    newPosition: newPosition
                }, null, function () {
                    orderInSameParent(reorderedQuestion.question, newPosition, reorderedQuestion.structure.Questions);
                });
            }
            else {//move to another parent
                if (isDown)
                    newPosition++;
                SurveysResource.MoveQuestionToStructure({
                    questionId: QuestionId,
                    structureId: newStructureId,
                    position: newPosition
                }, null, function () {
                    removeQuestionFromParent(reorderedQuestion);
                    ResetPosition((reorderedQuestion.structure || reorderedQuestion.parentQuestion).Questions);

                    var newStructure = $scope.selectedSurvey.findStructureById(newStructureId);
                    newStructure.Questions.push(reorderedQuestion.question);
                    reorderedQuestion.question.Position = Number.MAX_VALUE; //Set original position to a very big number as this is dragged from another parent

                    orderInSameParent(reorderedQuestion.question, newPosition, newStructure.Questions);
                });
            }
        }
    };

    $scope.reorderAnswer = function (answerId, currentQuestionId, newPosition, isDown, newQuestion) {
        if ($scope.selectedSurvey) {
            var currentQuestion = $scope.selectedSurvey.findQuestionById(currentQuestionId).question;
            var reorderedAnswer = $filter("filter")(currentQuestion.Answers, function (item) {
                return item.Id == answerId;
            })[0];

            if (currentQuestionId == newQuestion.Id) { //order in the same parent
                newPosition = calculateNewPosition(reorderedAnswer.Position, newPosition, isDown);

                AnswersResource.ReorderAnswerPosition({
                    answerId: answerId,
                    questionId: currentQuestionId,
                    newPosition: newPosition
                }, null, function () {
                    orderInSameParent(reorderedAnswer, newPosition, currentQuestion.Answers);
                });
            }
            else {
                //move to another parent
                if (isDown)
                    newPosition++;
                SurveysResource.MoveAnswerToQuestion({
                    answerId: answerId,
                    currentQuestionId: currentQuestionId,
                    questionId: newQuestion.Id,
                    position: newPosition
                }, null, function () {
                    currentQuestion.Answers.splice(currentQuestion.Answers.indexOf(reorderedAnswer), 1);
                    ResetPosition(currentQuestion.Answers);

                    newQuestion.Answers.push(reorderedAnswer);
                    reorderedAnswer.Position = Number.MAX_VALUE; //Set original position to a very big number as this is dragged from another parent

                    orderInSameParent(reorderedAnswer, newPosition, newQuestion.Answers);
                });
            }
        }
    };

    function orderByPosition(a, b) {
        if (a.Position < b.Position)
            return -1;
        if (a.Position > b.Position)
            return 1;
        return 0;
    };

    function ResetPosition(collections) {
        for (var i = 1; i <= collections.length; i++) {
            collections[i - 1].Position = i;
        }
    };

    $scope.reorderQuestionToParentQuestion = function (QuestionId, newPosition, isDown, newParentQuestionId) {
        if ($scope.selectedSurvey) {
            var reorderedQuestion = $scope.selectedSurvey.findQuestionById(QuestionId);

            if (reorderedQuestion.parentQuestion && reorderedQuestion.parentQuestion.Id == newParentQuestionId) {//order in the same parent
                newPosition = calculateNewPosition(reorderedQuestion.question.Position, newPosition, isDown);

                QuestionsResource.ReorderQuestionPosition({
                    questionId: reorderedQuestion.question.Id,
                    newPosition: newPosition
                }, null, function () {
                    orderInSameParent(reorderedQuestion.question, newPosition, reorderedQuestion.parentQuestion.Questions);
                });
            }
            else {//move to another parent
                if (isDown)
                    newPosition++;

                SurveysResource.MoveQuestionToQuestion({
                    questionId: QuestionId,
                    parentQuestionId: newParentQuestionId,
                    position: newPosition
                }, null, function () {
                    removeQuestionFromParent(reorderedQuestion);
                    ResetPosition((reorderedQuestion.structure || reorderedQuestion.parentQuestion).Questions);
                    var newParentQuestion = $scope.selectedSurvey.findQuestionById(newParentQuestionId);
                    newParentQuestion.question.Questions.push(reorderedQuestion.question);
                    reorderedQuestion.question.Position = Number.MAX_VALUE; //Set original position to a very big number as this is dragged from another parent
                    orderInSameParent(reorderedQuestion.question, newPosition, newParentQuestion.question.Questions);
                });
            }
        }
    };

    function calculateNewPosition(originalPosition, newItemPosition, isDown) {
        if (originalPosition > newItemPosition) {
            if (isDown) {
                newItemPosition++;
            }
        }
        else {
            if (!isDown) {
                newItemPosition--;
            }
        }

        return newItemPosition;
    }

    function orderInSameParent(orderedItem, newPosition, collections, isDown) {
        var originalPosition = orderedItem.Position;
        var moveToSmallerPosition;

        if (originalPosition > newPosition) {
            moveToSmallerPosition = true;
        }
        else {
            moveToSmallerPosition = false;
        }

        if (newPosition != originalPosition) {
            //call ajax to update server side. pass in structureId, newPosition

            //These lines are executed after ajax succeeded
            if (moveToSmallerPosition) {
                angular.forEach(collections, function (item, key) {
                    if (item.Id != orderedItem.Id && item.Position >= newPosition && item.Position < originalPosition) {
                        item.Position++;
                    }
                });
            }
            else {
                angular.forEach(collections, function (item, key) {
                    if (item.Id != orderedItem.Id && item.Position <= newPosition && item.Position > originalPosition) {
                        item.Position--;
                    }
                });
            }

            orderedItem.Position = newPosition;

            collections.sort(orderByPosition);
        }
    }

    $scope.reorderStructure = function (StructureId, newPosition, isDown) {
        if ($scope.selectedSurvey) {
            var reorderedStructure = $scope.selectedSurvey.findStructureById(StructureId);
            newPosition = calculateNewPosition(reorderedStructure.Position, newPosition, isDown);

            SurveyStructuresResource.ReorderStructurePosition({
                structureId: StructureId,
                newPosition: newPosition
            }, null, function () {
                orderInSameParent(reorderedStructure, newPosition, $scope.selectedSurvey.Structures);
            });
        }
    };

    $scope.moveQuestionToStructure = function (QuestionId, Structure) {
        SurveysResource.MoveQuestionToStructure({
            questionId: QuestionId,
            structureId: Structure.Id
        }, {}, function () {
            if ($scope.selectedSurvey) {
                var MovedItem = $scope.selectedSurvey.findQuestionById(QuestionId);
                if (MovedItem) {
                    removeQuestionFromParent(MovedItem);

                    if (Structure.isExpanded) {
                        Structure.Questions.push(MovedItem.question);
                    }
                    else {
                        $scope.expandStructure(Structure);
                    }
                }
            }
        }, function () {
        });
    };

    $scope.moveAnswerToQuestion = function (AnswerId, CurrentQuestionId, Question) {

        SurveysResource.MoveAnswerToQuestion({
            answerId: AnswerId,
            currentQuestionId: CurrentQuestionId,
            questionId: Question.Id
        }, {}, function () {
            if ($scope.selectedSurvey) {
                var currentQuestion = $scope.selectedSurvey.findQuestionById(CurrentQuestionId).question;
                var answer = $filter("filter")(currentQuestion.Answers, function (item) {
                    return item.Id == AnswerId;
                })[0];

                currentQuestion.Answers.splice(currentQuestion.Answers.indexOf(answer), 1);

                if (Question.isExpanded) {
                    Question.Answers.push(answer);
                }
                else {
                    $scope.expandQuestion(Question);
                }
            }
        }, function () {
        });

    };

    function removeQuestionFromParent(MovedItem) {
        if (MovedItem) {
            if (MovedItem.structure) {
                MovedItem.structure.Questions.splice(MovedItem.structure.Questions.indexOf(MovedItem.question), 1);
            }
            else if (MovedItem.parentQuestion) {
                MovedItem.parentQuestion.Questions.splice(MovedItem.parentQuestion.Questions.indexOf(MovedItem.question), 1);
            }
        }
    };

    $scope.moveQuestionToQuestion = function (QuestionId, ParentQuestion) {
        if (QuestionId != ParentQuestion.Id) { //Check 1 more condition to prevent dragging to its subquestion.
            SurveysResource.MoveQuestionToQuestion({
                questionId: QuestionId,
                parentQuestionId: ParentQuestion.Id
            }, {},
                function () {

                    if ($scope.selectedSurvey) {
                        var MovedItem = $scope.selectedSurvey.findQuestionById(QuestionId);
                        if (MovedItem) {
                            removeQuestionFromParent(MovedItem);

                            if (ParentQuestion.isExpanded) {
                                ParentQuestion.Questions.push(MovedItem.question);
                            }
                            else {
                                $scope.expandQuestion(ParentQuestion);
                            }
                        }
                    }

                },
                function () {
                    //error
                });
        }
    };

    $scope.deleteAnswerValue = function (answerValue, editingAnswer) {
        var childScope = $scope.$new();

        childScope.confirm = function () {

            AnswerValuesResource['delete']({
                id: answerValue.Id
            }, function () {

                editingAnswer.answerValues.splice(editingAnswer.answerValues.indexOf(answerValue), 1);

                childScope.dismiss();
            }, function () {
            });

        }

        var modalPromise = $modal({ template: 'confirmationDialog.html', persist: true, show: false, backdrop: 'static', scope: childScope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
        });
    };

    $scope.updateAnswerValue = function (editingAnswerValue, dismiss) {
        if (!editingAnswerValue.AnswerValue || !editingAnswerValue.AnswerText) {
            return;
        }

        var postData = {
            AnswerValue: editingAnswerValue.AnswerValue,
            AnswerText: editingAnswerValue.AnswerText
        };

        if (editingAnswerValue.Id > 0) { //Update
            AnswerValuesResource.save({
                id: editingAnswerValue.Id,
                languageId: languageId,
                surveyId: $scope.selectedSurvey.Id
            }, postData, function () {

                $scope.selectedAnswerValue.AnswerValue = editingAnswerValue.AnswerValue;
                $scope.selectedAnswerValue.AnswerText = editingAnswerValue.AnswerText;

                dismiss();
            }, function () {
                //error
            });
        }
        else {
            postData.AnswerId = editingAnswerValue.answer.Id;
            AnswerValuesResource.save({
                languageId: languageId,
                surveyId: $scope.selectedSurvey.Id
            }, postData, function (newAnswerValue) {

                editingAnswerValue.Id = newAnswerValue.Id;
                $scope.selectedAnswerValue.answer.answerValues.push(editingAnswerValue);

                dismiss();
            }, function () {
            });
        }
    };

    $scope.editSurveyQuestion = function (question) {
        $scope.selectedQuestion = question;

        var scope = $scope.$new();
        scope.question = {};
        scope.question.Id = question.Id;
        scope.question.QuestionName = question.QuestionName;
        scope.question.Comment = question.Comment;
        scope.question.Header = question.Header;
        scope.question.CalculateAnswerAverage = question.CalculateAnswerAverage;
        scope.question.IsContactInfo = question.IsContactInfo;
        scope.question.structure = question.structure;
        scope.question.parentQuestion = question.parentQuestion;
        scope.question.QuestionTypeId = question.QuestionTypeId;

        scope.QuestionTypes = QuestionTypesResource.query({
            languageId: languageId
        });

        var modalPromise = $modal({ template: 'surveyQuestionPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
            setTimeout(function () {
                $("select, input").uniform();
                $("select, input").uniform.update();
            }, 500);
        });
    };

    function editAnswer(answer) {
        this.selectedAnswer = answer;
        this.editingAnswer = angular.copy(answer);

        this.loadAnswerValues(0, answerValuesPageSize);
    };

    function loadAnswerValues(pageIndex, pageSize) {
        var scope = this;
        if (scope.editingAnswer) {
            if (scope.editingAnswer.AnswerTypeId == $scope.ANSWER_TYPE.DROP_DOWN && scope.editingAnswer.Id > 0) {
                AnswerValuesResource.query({
                    surveyId: $scope.selectedSurvey.Id,
                    answerId: scope.editingAnswer.Id,
                    languageId: languageId,
                    pageIndex: pageIndex,
                    pageSize: pageSize
                }, function (answerValues, responseHeaders) {
                    scope.editingAnswer.answerValues = answerValues;

                    scope.editingAnswer.currentPage = pageIndex;
                    scope.editingAnswer.pageSize = pageSize;
                    scope.editingAnswer.totalRows = responseHeaders("TotalRows");
                });
            }
        }
    };

    function saveUpdateAnswerToServer() {
        if (!this.editingAnswer.AnswerName || !this.editingAnswer.AnswerTypeId)
            return;

        var postData = {
            AnswerName: this.editingAnswer.AnswerName,
            AnswerTypeId: this.editingAnswer.AnswerTypeId,
            Value: this.editingAnswer.Value
        };

        var deferred = $q.defer();

        if (this.editingAnswer.Id > 0) { //Update
            AnswersResource.UpdateAnswer({
                id: this.editingAnswer.Id,
                languageId: languageId,
                surveyId: $scope.selectedSurvey.Id
            }, postData, function () {
                deferred.resolve.apply(deferred, arguments);
            }, function () {
                deferred.reject.apply(deferred, arguments);
            });
        }
        else {//insert
            AnswersResource.InsertAnswer({
                languageId: languageId,
                surveyId: $scope.selectedSurvey.Id
            }, postData, function () {
                deferred.resolve.apply(deferred, arguments);
            }, function () {
                deferred.reject.apply(deferred, arguments);
            });
        }

        return deferred.promise;
    };

    $scope.openAnswerPopup = function (answer) {
        var scope = $scope.$new();

        scope.loadAnswerValues = loadAnswerValues.bind(scope);

        editAnswer.call(scope, answer);

        scope.Filter = {
            Dropdowns: {
                AnswerTypes: AnswersResource.GetAnswerTypes({
                    languageId: languageId
                })
            }
        };

        scope.saveUpdateAnswerToServer = saveUpdateAnswerToServer.bind(scope);

        scope.updateAnswer = function (dismiss) {
            var promise = scope.saveUpdateAnswerToServer();
            if (!promise) {
                return;
            }

            if (this.editingAnswer.Id > 0) { //Update
                promise.then(function () {
                    var answerType = $filter("filter")(scope.Filter.Dropdowns.AnswerTypes, function (answerType) { //improve later, need to ensure that scope.Filter.Dropdowns.AnswerTypes is available before opening popup. 
                        return answerType.Id == scope.editingAnswer.AnswerTypeId;
                    });

                    var AnswerTypeId = scope.editingAnswer.AnswerTypeId;
                    var AnswerTypeName = scope.editingAnswer.AnswerTypeName;
                    var Value = scope.editingAnswer.Value;

                    if (answerType.length > 0) {
                        AnswerTypeId = answerType[0].Id;
                        AnswerTypeName = answerType[0].AnswerTypeName;
                    }

                    if ($scope.selectedSurvey) {
                        $scope.selectedSurvey.RefreshAllAnswer(scope.editingAnswer.Id, scope.editingAnswer.AnswerName, AnswerTypeId, AnswerTypeName, Value);
                    }

                    dismiss();
                }, function () {
                    //error
                });
            } else {//Insert

            }
        };

        var modalPromise = $modal({ template: 'answerDetailPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
        });
    };

    $scope.addAnswerPopup = function (question) {
        var scope = $scope.$new();

        scope.selectedQuestion = question;

        scope.loadAnswersNotAssignToQuestion = function (pageIndex, pageSize, query, sortColumn, isAscending) {
            AnswersResource.GetAnswersNotAssignToQuestion({
                languageId: languageId,
                questionId: scope.selectedQuestion.Id,
                answerType: query.AnswerTypeID,
                answerName: query.AnswerName,
                sortColumn: sortColumn,
                isAscending: isAscending,
                pageIndex: pageIndex,
                pageSize: pageSize
            }, function (answers, responseHeaders) {
                scope.Answers = answers;
                scope.currentPage = pageIndex;
                scope.pageSize = pageSize;
                scope.totalRows = responseHeaders("TotalRows");

                if (query == scope.Filter.tmpquery) {
                    scope.Filter.query = angular.copy(scope.Filter.tmpquery);
                }

                scope.Sort.sortColumn = sortColumn;
                scope.Sort.isAscending = isAscending;

            }, function () {
                if (query == $scope.Filter.tmpquery) {
                    scope.Filter.tmpquery = angular.copy(scope.Filter.query);
                }

                scope.Sort.tmp_sortColumn = scope.Sort.sortColumn;
                scope.Sort.tmp_isAscending = scope.Sort.isAscending;
            });
        }

        scope.startFiltering = function (event) {
            if (event.keyCode == 13) {
                scope.Filter.search();
            }
        }

        scope.Sort =
        {
            sortColumn: 2,
            isAscending: true,
            tmp_sortColumn: 2,
            tmp_isAscending: true,
            Sort: function (sortColumn) {
                if (this.sortColumn === sortColumn) {
                    this.tmp_isAscending = !this.isAscending;
                }
                else {
                    this.tmp_sortColumn = sortColumn;
                    this.tmp_isAscending = false;
                }

                scope.loadAnswersNotAssignToQuestion(0, scope.pageSize, scope.Filter.query, this.tmp_sortColumn, this.tmp_isAscending);
            }
        };

        scope.Filter =
        {
            showFilter: false,
            tmpquery: {
                AnswerTypeID: null,
                AnswerName: ""
            },
            query: {
                AnswerTypeID: null,
                AnswerName: ""
            },
            Dropdowns: {
                AnswerTypes: AnswersResource.GetAnswerTypes({
                    languageId: languageId
                })
            },
            toggleFilter: function () {
                this.showFilter = !this.showFilter;
                //if (this.showFilter && !this.Dropdowns.AnswerTypes) {
                //    this.Dropdowns.AnswerTypes = AnswersResource.GetAnswerTypes({
                //        languageId: languageId
                //    });
                //}
            },
            search: function () {
                scope.loadAnswersNotAssignToQuestion(0, scope.pageSize, this.tmpquery, scope.Sort.sortColumn, scope.Sort.isAscending);
            },
            reset: function () {
                this.tmpquery.AnswerTypeID = null;
                this.tmpquery.AnswerName = "";

                this.search();
            }
        };

        scope.loadAnswersNotAssignToQuestion(0, answersPageSize, scope.Filter.query, scope.Sort.sortColumn, scope.Sort.isAscending);

        scope.$on('pageIndexChanged', function (event, page) {
            if (event.targetScope.identifier == "Answers") {
                scope.loadAnswersNotAssignToQuestion(page, answersPageSize, scope.Filter.query, scope.Sort.sortColumn, scope.Sort.isAscending);
            }

            if (event.targetScope.identifier == "AnswerValues") {
                scope.loadAnswerValues(page, answerValuesPageSize);
            }
        });

        scope.loadAnswerValues = loadAnswerValues.bind(scope);

        scope.editAnswer = editAnswer.bind(scope);

        scope.backtoList = function () {
            scope.selectedAnswer = null;
            scope.editingAnswer = null;
        };

        scope.addAnswer = function () {
            scope.editAnswer({});
        };

        scope.deleteAnswers = function () {

            var childScope = scope.$new();

            childScope.confirm = function () {

                var selectedAnswers = $filter("filter")(scope.Answers, function (answer) {
                    return answer.selected;
                });

                var selectedAnswerIds = $.map(selectedAnswers, function (answer) {
                    return answer.Id;
                });

                AnswersResource.DeleteAnswers(selectedAnswerIds, function () {

                    $.each(selectedAnswers, function () {
                        scope.Answers.splice(scope.Answers.indexOf(this), 1);
                    });

                    childScope.dismiss();
                }, function () {
                });

            }

            var modalPromise = $modal({ template: 'confirmationDialog.html', persist: true, show: false, backdrop: 'static', scope: childScope });
            $q.when(modalPromise).then(function (modalEl) {
                modalEl.modal('show');
            });
        };

        scope.saveUpdateAnswerToServer = saveUpdateAnswerToServer.bind(scope);

        scope.updateAnswer = function () {
            var promise = scope.saveUpdateAnswerToServer();
            if (!promise) {
                return;
            }

            if (this.editingAnswer.Id > 0) { //Update
                promise.then(function () {

                    //Need refactoring to move all logic to RefreshAllAnswer function
                    scope.selectedAnswer.AnswerName = scope.editingAnswer.AnswerName;
                    scope.selectedAnswer.Value = scope.editingAnswer.Value;

                    var answerType = $filter("filter")(scope.Filter.Dropdowns.AnswerTypes, function (answerType) { //improve later, need to ensure that scope.Filter.Dropdowns.AnswerTypes is available before opening popup. 
                        return answerType.Id == scope.editingAnswer.AnswerTypeId;
                    });

                    if (answerType.length > 0) {
                        scope.selectedAnswer.AnswerTypeId = answerType[0].Id;
                        scope.selectedAnswer.AnswerTypeName = answerType[0].AnswerTypeName;
                    }
                    //////

                    if ($scope.selectedSurvey) {
                        $scope.selectedSurvey.RefreshAllAnswer(scope.editingAnswer.Id, scope.selectedAnswer.AnswerName, scope.selectedAnswer.AnswerTypeId,
                            scope.selectedAnswer.AnswerTypeName, scope.editingAnswer.Value);
                    }

                    scope.backtoList();
                }, function () {
                    //error
                });
            } else {//Insert
                promise.then(function (newAnswer) {
                    scope.editingAnswer.Id = newAnswer.Id;

                    var answerType = $filter("filter")(scope.Filter.Dropdowns.AnswerTypes, function (answerType) { //improve later, need to ensure that scope.Filter.Dropdowns.AnswerTypes is available before opening popup. 
                        return answerType.Id == scope.editingAnswer.AnswerTypeId;
                    });

                    if (answerType.length > 0) {
                        scope.editingAnswer.AnswerTypeId = answerType[0].Id;
                        scope.editingAnswer.AnswerTypeName = answerType[0].AnswerTypeName;
                    }

                    scope.editingAnswer.selected = true; //automatically select this answer for user convenience
                    scope.Answers.push(scope.editingAnswer);

                    scope.backtoList();
                }, function () {
                    //error
                });
            }
        };

        var modalPromise = $modal({ template: 'answerPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
            setTimeout(function () {
                $("select, input").uniform();
                $("select, input").uniform.update();
            }, 500);
        });
    };

    $scope.configureSurveySetting = function (survey) {
        var scope = $scope.$new();

        SurveysResource.LoadSurveySettings({
            surveyId: $scope.selectedSurvey.Id,
            languageId: languageId
        }, function (settings) {
            scope.SurveySettings = settings;


            var modalPromise = $modal({ template: 'surveySettingsPopup.html', persist: true, show: false, backdrop: 'static', scope: scope });
            $q.when(modalPromise).then(function (modalEl) {
                modalEl.modal('show');
            });
        });
    };

    $scope.saveSurveySettings = function () {

        SurveysResource.SaveSurveySettings({
            surveyId: $scope.selectedSurvey.Id,
            languageId: languageId
        }, this.SurveySettings, function () {

            this.dismiss();
        } .bind(this));
    };

    $scope.deleteText = function (Text, structure) {

        var childScope = $scope.$new();

        childScope.confirm = function () {

            SurveyStructuresResource.DeleteStructureText({
                textId: Text.Id
            }, function () {

                structure.Texts.splice(structure.Texts.indexOf(Text), 1);

                childScope.dismiss();
            }, function () {
            });

        }

        var modalPromise = $modal({ template: 'confirmationDialog.html', persist: true, show: false, backdrop: 'static', scope: childScope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
        });

    };

    $scope.deleteImage = function (Image, structure) {

        var childScope = $scope.$new();

        childScope.confirm = function () {

            SurveyStructuresResource.DeleteStructureImage({
                imageId: Image.Id,
                surveyId: $scope.selectedSurvey.Id
            }, function () {

                structure.Images.splice(structure.Images.indexOf(Image), 1);

                childScope.dismiss();
            }, function () {
            });

        };

        var modalPromise = $modal({ template: 'confirmationDialog.html', persist: true, show: false, backdrop: 'static', scope: childScope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
        });

    };

    $scope.addNewTextToStructure = function (structure) {
        this.editStructureText({});

        this.editingText.structure = structure;
    };

    $scope.addNewImageToStructure = function (structure) {
        this.editStructureImage({}, structure);

    };

    $scope.editStructureText = function (Text) {
        this.selectedText = Text;
        this.editingText = angular.copy(Text);
    };

    $scope.editStructureImage = function (Image, structure) {
        this.selectedImage = Image;
        this.editingImage = angular.copy(Image);
        this.editingImage.structure = structure;
    };



    $scope.uploadStructureImage = function (event, editingImage, dismiss) {
        if (!editingImage.Name) {
            return;
        }

        // console.log(editingImage);
        var postData = {
            Id: editingImage.Id,
            Name: editingImage.Name,
            Description: editingImage.Description
        };

        var fileInput = $(event.target).find("[type=file]")[0];

        if (fileInput.value) { //user selects a file to upload

            fileInput.fileData.formData = { imageObj: angular.toJson(postData), structureId: editingImage.structure.Id };

            //$(".modal-loading").show();

            fileInput.fileData.submit()
                .done(function (newImage) {

                    var scope = this;

                    this.$apply(function () {

                        scope.selectedImage.FileName = newImage.FileName;
                        scope.selectedImage.Url = newImage.Url;
                        scope.selectedImage.Name = editingImage.Name;
                        scope.selectedImage.Description = editingImage.Description;

                        if (newImage.Id) {
                            scope.selectedImage.Id = newImage.Id;
                            //editingImage.structure.Images.push(scope.selectedImage);
                            // console.log(scope.selectedImage);
                            if (editingImage.structure.Images == undefined || editingImage.structure.Images == '' || editingImage.structure.Images == null)
                                editingImage.structure.Images = [];
                            editingImage.structure.Images.push(scope.selectedImage);
                        }

                    });
                    //$(".modal-loading").fadeOut(1500);
                    dismiss();
                } .bind(this))
                .fail(function () {

                } .bind(this));
        }
        else { //just update image text fields
            if (editingImage.Id > 0) { //Update
                SurveyStructuresResource.UpdateStructureImage({
                    languageId: languageId
                }, postData, function () {

                    this.selectedImage.Name = editingImage.Name;
                    this.selectedImage.Description = editingImage.Description;

                    dismiss();
                } .bind(this), function () {
                    //error
                } .bind(this));
            }
            else {
                SurveyStructuresResource.InsertStructureImage({
                    structureId: editingImage.structure.Id,
                    languageId: languageId
                }, postData, function (newImage) {

                    this.selectedImage.Id = newImage.Id;
                    this.selectedImage.Name = editingImage.Name;
                    this.selectedImage.Description = editingImage.Description;

                    //editingImage.structure.Images.push(this.selectedImage);

                    dismiss();
                } .bind(this), function () {
                    //error
                } .bind(this));
            }
        }
    };

    $scope.updateStructureText = function (editingText, dismiss) {
        editingText.Value = getWYSIWYGText(document.getElementById("textValue"));

        if (!editingText.Name) {
            return;
        }

        var postData = {
            Id: editingText.Id,
            Name: editingText.Name,
            Value: editingText.Value
        };

        if (editingText.Id > 0) { //Update
            SurveyStructuresResource.UpdateStructureText({
                languageId: languageId
            }, postData, function () {

                this.selectedText.Name = editingText.Name;
                this.selectedText.Value = editingText.Value;

                dismiss();
            } .bind(this), function () {
                //error
            } .bind(this));
        }
        else {
            SurveyStructuresResource.InsertStructureText({
                structureId: editingText.structure.Id,
                languageId: languageId
            }, postData, function (newText) {

                this.selectedText.Id = newText.Id;
                this.selectedText.Name = editingText.Name;
                this.selectedText.Value = editingText.Value;
                if (editingText.structure.Texts == undefined || editingText.structure.Texts == '' || editingText.structure.Texts == null)
                    editingText.structure.Texts = [];
                editingText.structure.Texts.push(this.selectedText);

                dismiss();
            } .bind(this), function () {
                //error
            } .bind(this));
        }
    };

    $scope.assignAnswers = function (scope, dismiss, isClose) {
        var selectedAnswers = $filter("filter")(scope.Answers, function (answer) {
            return answer.selected;
        });

        var selectedAnswerIds = $.map(selectedAnswers, function (answer) {
            return answer.Id;
        });

        QuestionsResource.AssignAnswers({
            questionId: scope.selectedQuestion.Id
        }, selectedAnswerIds
        , function () {
            var currentAnswers = scope.selectedQuestion.Answers;
            if (scope.selectedQuestion.isExpanded) {
                currentAnswers.push.apply(currentAnswers, selectedAnswers);
                ResetPosition(currentAnswers);
            }
            else {
                $scope.expandQuestion(scope.selectedQuestion);
            }

            if (isClose) {
                dismiss();
            }
            else {
                scope.loadAnswersNotAssignToQuestion(scope.currentPage, scope.pageSize, scope.Filter.query, scope.Sort.sortColumn, scope.Sort.isAscending);
            }
        }, function () {
        });
    };

    $scope.removeAnswerFromQuestion = function (Question, Answer) {

        var scope = $scope.$new();
        scope.confirm = function () {
            QuestionsResource.RemoveAnswerFromQuestion({
                id: Question.Id,
                answerId: Answer.Id
            }, null,
            function () {
                if (Question.Answers) {
                    Question.Answers.splice(Question.Answers.indexOf(Answer), 1);
                }

                scope.dismiss();
            }, function () {

            });
        };

        var modalPromise = $modal({ template: 'confirmationDialog.html', persist: true, show: false, backdrop: 'static', scope: scope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
        });
    };

    $scope.deleteQuestion = function (question) {
        var parentScope = this.$parent.$parent; //at the moment, cannot initialize ng-include's scope, so ng-include current scope is accessing $parent => $parent.$parent is parent of current scope. Should search angular doc for solution to initialize ng-include's scope
        var scope = $scope.$new();
        scope.confirm = function () {
            QuestionsResource.DeleteQuestion({
                id: question.Id
            }, function () {
                if (!parentScope.Question) {//this is root question
                    parentScope.Structure.Questions.splice(parentScope.Structure.Questions.indexOf(question), 1);
                }
                else {//Sub question
                    parentScope.Question.Questions.splice(parentScope.Question.Questions.indexOf(question), 1);
                }
                scope.dismiss();
            }, function () {
            });
        }

        var modalPromise = $modal({ template: 'confirmationDialog.html', persist: true, show: false, backdrop: 'static', scope: scope });
        $q.when(modalPromise).then(function (modalEl) {
            modalEl.modal('show');
        });
    };

    $scope.backtoList = function () {
        $scope.selectedSurvey = null;
    };
}