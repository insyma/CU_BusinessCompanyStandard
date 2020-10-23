var surveyResources = angular.module("SurveyResources", ['ngResource']);

surveyResources.factory("surveyResourcesAlt", function ($resource) {
    return $resource(APP_ROOT + "SurveyGeneral/:action/:id", { id: '@id', action: '' }, {
        PublishSurvey: {
            method: "GET",
            params: { action: 'PublishSurvey' }
        }
    }
    );
});

surveyResources.factory("SurveysResource", function ($resource) {
    return $resource(APP_ROOT + "api/Surveys/:action/:id", { id: '@id', action: '' }, {
        DeleteSurvey: {
            method: "DELETE",
            params: { action: 'DeleteSurvey' }
        },
        LoadSurvey: {
            method: "GET",
            isArray: true,
            params: { action: 'LoadSurvey' }
        },
        InsertSurvey: {
            method: "POST",
            params: { action: 'InsertSurvey' }
        },
        UpdateSurvey: {
            method: "POST",
            params: { action: 'UpdateSurvey' }
        },
        MoveQuestionToQuestion: {
            method: "POST",
            params: { action: 'MoveQuestionToQuestion' }
        },
        MoveQuestionToStructure: {
            method: "POST",
            params: { action: 'MoveQuestionToStructure' }
        },
        MoveAnswerToQuestion: {
            method: "POST",
            params: { action: 'MoveAnswerToQuestion' }
        },
        PublishSurvey: {
            method: "POST",
            params: { action: 'PublishSurvey' }
        },
        LoadDependencyGroupTypes: {
            method: "GET",
            isArray: true,
            params: { action: 'LoadDependencyGroupTypes' }
        },
        UpdateDependencyGroup: {
            method: "POST",
            params: { action: 'UpdateDependencyGroup' }
        },
        UpdateDependency: {
            method: "POST",
            params: { action: 'UpdateDependency' }
        },
        CreateDependencyGroup: {
            method: "POST",
            params: { action: 'CreateDependencyGroup' }
        },
        AddNewDependency: {
            method: "POST",
            params: { action: 'AddNewDependency' }
        },
        DeleteDependency: {
            method: "DELETE",
            params: { action: 'DeleteDependency' }
        },
        DeleteDependencyGroup: {
            method: "DELETE",
            params: { action: 'DeleteDependencyGroup' }
        },
        LoadSurveySettings: {
            method: "GET",
            isArray: true,
            params: { action: 'LoadSurveySettings' }
        },
        SaveSurveySettings: {
            method: "POST",
            isArray: true,
            params: { action: 'SaveSurveySettings' }
        }
    });
});

surveyResources.factory("SurveyStructuresResource", function ($resource) {
    return $resource(APP_ROOT + "api/SurveyStructures/:action/:id", { id: '@id', action: '' }, {
        DeleteSurveyStructure: {
            method: "DELETE",
            params: { action: 'DeleteSurveyStructure' }
        },
        ReorderStructurePosition: {
            method: "POST",
            params: { action: 'ReorderStructurePosition' }
        },
        LoadDependencies: {
            method: "GET",
            params: { action: 'LoadDependencies' }
        },
        CreateRootDependencyGroup: {
            method: "POST",
            params: { action: 'CreateRootDependencyGroup' }
        },
        UpdateSurveyStructure: {
            method: "POST",
            params: { action: 'UpdateSurveyStructure' }
        },
        InsertSurveyStructure: {
            method: "POST",
            params: { action: 'InsertSurveyStructure' }
        },
        GetBySurveyId: {
            method: "GET",
            isArray: true,
            params: { action: 'GetBySurveyId' }
        },
        LoadStructureTextsAndImages: {
            method: "GET",
            params: { action: 'LoadStructureTextsAndImages' }
        },
        UpdateStructureText: {
            method: "POST",
            params: { action: 'UpdateStructureText' }
        },
        InsertStructureText: {
            method: "POST",
            params: { action: 'InsertStructureText' }
        },
        DeleteStructureText: {
            method: "DELETE",
            params: { action: 'DeleteStructureText' }
        },
        UpdateStructureImage: {
            method: "POST",
            params: { action: 'UpdateStructureImage' }
        },
        InsertStructureImage: {
            method: "POST",
            params: { action: 'InsertStructureImage' }
        },
        DeleteStructureImage: {
            method: "DELETE",
            params: { action: 'DeleteStructureImage' }
        }
    });
});

surveyResources.factory("QuestionTypesResource", function ($resource) {
    return $resource(APP_ROOT + "api/QuestionTypes/:id");
});

surveyResources.factory("QuestionsResource", function ($resource) {
    return $resource(APP_ROOT + "api/Questions/:action/:id", { id: '@id', action: '' }, {
        GetByStructureId: {
            method: "GET",
            isArray: true,
            params: { action: 'GetByStructureId' }
        },
        GetByParentId: {
            method: "GET",
            isArray: false,
            params: { action: 'GetByParentId' }
        },
        AssignAnswers: {
            method: "POST",
            isArray: true,
            params: { action: 'AssignAnswers' }
        },
        RemoveAnswerFromQuestion: {
            method: "POST",
            params: { action: 'RemoveAnswerFromQuestion' }
        },
        ReorderQuestionPosition: {
            method: "POST",
            params: { action: 'ReorderQuestionPosition' }
        },
        GetAllRootQuestions: {
            method: "GET",
            isArray: true,
            params: { action: 'GetAllRootQuestions' }
        },
        LoadDependencies: {
            method: "GET",
            params: { action: 'LoadDependencies' }
        },
        CreateRootDependencyGroup: {
            method: "POST",
            params: { action: 'CreateRootDependencyGroup' }
        },
        UpdateQuestion: {
            method: "POST",
            params: { action: 'UpdateQuestion' }
        },
        InsertQuestion: {
            method: "POST",
            params: { action: 'InsertQuestion' }
        },
        DeleteQuestion: {
            method: "POST",
            params: { action: 'DeleteQuestion' }
        },
        LoadQuestionContactMapping: {
            isArray: false,
            method: "GET",
            params: { action: 'LoadQuestionContactMapping' }
        },
        SaveQuestionContactMapping: {
            method: "POST",
            params: { action: 'SaveQuestionContactMapping' }
        },
        LoadQuestionAnswerContactMapping: {
            isArray: false,
            method: "GET",
            params: { action: 'LoadQuestionAnswerContactMapping' }
        },
        SaveQuestionAnswerContactMapping: {
            method: "POST",
            params: { action: 'SaveQuestionAnswerContactMapping' }
        }
    });
});

surveyResources.factory("AnswersResource", function ($resource) {
    return $resource(APP_ROOT + "api/Answers/:action/:id", { id: '@id', action: '' }, {
        GetAnswersNotAssignToQuestion: {
            method: "GET",
            isArray: true,
            params: { action: 'GetAnswersNotAssignToQuestion' }
        },
        GetAnswerTypes: {
            method: "GET",
            isArray: true,
            params: { action: 'GetAnswerTypes' }
        },
        DeleteAnswers: {
            method: "POST",
            isArray: true,
            params: { action: 'DeleteAnswers' }
        },
        ReorderAnswerPosition: {
            method: "POST",
            params: { action: 'ReorderAnswerPosition' }
        },
        UpdateAnswer: {
            method: "POST",
            params: { action: 'UpdateAnswer' }
        },
        InsertAnswer: {
            method: "POST",
            params: { action: 'InsertAnswer' }
        }
    });
});

surveyResources.factory("AnswerValuesResource", function ($resource) {
    return $resource(APP_ROOT + "api/AnswerValues/:id");
});