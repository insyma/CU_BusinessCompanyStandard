
var ContentPropertyField = {};

(function () {
    var _this = this;
    
    function getContentPropertySources() {
        //ContentPropertySource got from view
        return ContentPropertySource;
    }
    
    function isFieldTypeEqual(fieldType, fieldTypes) {
        return (fieldType != null && fieldTypes != null && fieldType.toLocaleLowerCase() == fieldTypes.toLocaleLowerCase());
    }
        
    function isFieldKeyEqual(fieldKey, fieldKey2) {
        return (fieldKey != null && fieldKey2 != null && fieldKey.toLocaleLowerCase() == fieldKey2.toLocaleLowerCase());
    }

    this.IsTextbox = function (fieldType) {
        return isFieldTypeEqual(fieldType, "Textbox");
    };

    this.IsTextarea = function(fieldType) {
        return isFieldTypeEqual(fieldType, "Textarea");
    };

    this.IsWysiwyg = function(fieldType) {
        return isFieldTypeEqual(fieldType, "Wysiwyg");
    };

    this.IsDropdown = function(fieldType) {
        return isFieldTypeEqual(fieldType, "Dropdown");
    };

    this.IsCheckbox = function(fieldType) {
        return isFieldTypeEqual(fieldType, "Checkbox");
    };

    this.IsDate = function(fieldType) {
        return isFieldTypeEqual(fieldType, "Date");
    };

    this.IsDateTime = function(fieldType) {
        return isFieldTypeEqual(fieldType, "DateTime");
    };

    this.IsMenuTextbox = function(fieldType) {
        return isFieldTypeEqual(fieldType, "MenuTextbox");
    };

    /*Field key */
    this.IsSwitchDelete = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_SwitchDelete");
    };
    
    this.IsSwitchArchive = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_SwitchArchive");
    };
    
    this.IsContentOrigin = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentOrigin") || isFieldKeyEqual(fieldKey, "CoFi_ContentOrigin_Pending");
    };
    
    this.IsContentType = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentType") || isFieldKeyEqual(fieldKey, "CoFi_ContentType_Pending");
    };
    
    this.IsContentTheme = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentTheme") || isFieldKeyEqual(fieldKey, "CoFi_ContentTheme_Pending");
    };
    
    this.IsContentMeetingPlace = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentMeetingPlace");
    };
    
    this.IsContentTag = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentTag") || isFieldKeyEqual(fieldKey, "CoFi_ContentTag_Pending");
    };
    
    this.IsContentProject = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentProject") || isFieldKeyEqual(fieldKey, "CoFi_ContentProject_Pending");
    };
    
    this.IsContentDossier = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentDossier") || isFieldKeyEqual(fieldKey, "CoFi_ContentDossier_Pending");
    };
    
    this.IsContentExpressionLinking = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentExpressionLinking");
    };
    
    this.IsContentExpressionGlossary = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_ContentExpressionGlossary");
    };

    this.IsAuthor = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_Author");
    };
    
    this.IsPublisher = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_Publisher");
    };
    
    this.IsResponsible = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_Responsible");
    };
    
    this.IsRightsUserGroup = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_RightsUserGroup");
    };
    
    this.IsRightsUserGroupRoleBased = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_RightsUserGroupRoleBased");
    };
    
    this.IsRightsUserContent = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_RightsUserContent");
    };
    
    this.IsOptionalPerson = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_OptionalPerson");
    };
    
    this.IsInvitedPerson = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_InvitedPerson");
    };
    
    this.IsSettingsPageSize = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_Settings_PageSize");
    };
    
    this.IsSettingsSortBy = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_Settings_SortBy");
    };
    
    this.IsSettingsFilter = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_Settings_Filter");
    };
    
    this.IsSettingsAllowFilterBy = function (fieldKey) {
        return isFieldKeyEqual(fieldKey, "CoFi_Settings_AllowFilterBy");
    };

    this.GetOriginContentDataSource = function () {
        var propertySources = getContentPropertySources();
        return (propertySources == null) ? null : propertySources.CoFi_ContentOrigin;
    };

    this.GetDataSource = function (fieldKey) {
        var propertySources = getContentPropertySources();
        
        if (propertySources == null || fieldKey == null) return null;
        
        switch (true) {
            case _this.IsContentOrigin(fieldKey):                
                return $.merge($.merge($.merge([], propertySources.CoFi_ContentOrigin), _this.ContactLoginDataSource()), _this.ContactLoginGroupDataSource());                                
            case _this.IsContentType(fieldKey):
                return propertySources.CoFi_ContentType;
            case _this.IsContentTheme(fieldKey):
                return propertySources.CoFi_ContentTheme;
            case _this.IsContentMeetingPlace(fieldKey):
                return propertySources.CoFi_ContentMeetingPlace;
            case _this.IsContentTag(fieldKey):
                return propertySources.CoFi_ContentTag;
            case _this.IsContentProject(fieldKey):
                return propertySources.CoFi_ContentProject;
            case _this.IsContentDossier(fieldKey):
                return propertySources.CoFi_ContentDossier;
            case _this.IsContentExpressionLinking(fieldKey):
                return propertySources.CoFi_ContentExpressionLinking;
            case _this.IsContentExpressionGlossary(fieldKey):
                return propertySources.CoFi_ContentExpressionGlossary;
            case _this.IsSettingsAllowFilterBy(fieldKey):
                return propertySources.CoFi_Settings_AllowFilterBy;
            case _this.IsAuthor(fieldKey):                
            case _this.IsPublisher(fieldKey):                
            case _this.IsResponsible(fieldKey):                
            case _this.IsRightsUserGroup(fieldKey):            
            case _this.IsRightsUserGroupRoleBased(fieldKey):
            case _this.IsRightsUserContent(fieldKey):
            case _this.IsOptionalPerson(fieldKey):
            case _this.IsInvitedPerson(fieldKey):
                return $.merge($.merge([], _this.ContactDataSource()), _this.ContactLoginGroupDataSource());            
            default:
                return null;
        }
    };

    this.ContactDataSource = function () {
        var propertySources = getContentPropertySources();

        return (propertySources == null) ? null : propertySources.ContactList;
    };
    
    this.ContactLoginDataSource = function () {
        var propertySources = getContentPropertySources();
        return (propertySources == null) ? null : propertySources.ContactLoginList;
    };

    this.ContactLoginGroupDataSource = function () {
        var propertySources = getContentPropertySources();
        return (propertySources == null) ? null : propertySources.ContactLoginGroupList;
    };

    this.ContactLoginGroupTreeDataSource = function () {
        var propertySources = getContentPropertySources();
        return (propertySources == null) ? null : propertySources.ContactLoginGroupTree;
    };

    this.GetDataField = function ($fieldElement) {
        var data = {};

        if (isJqueryObject($fieldElement)) {
            var fieldType = getFieldType($fieldElement);
            var fieldKey = getFieldKey($fieldElement);

            data.StructureId = getStructureId($fieldElement);
            data.FieldType = fieldType;
            data.FieldKey = fieldKey;
            
            switch (true) {
                case _this.IsSettingsPageSize(fieldKey):
                    data.StringValue = _this.GetIntValue($fieldElement);//settings has value is a string
                    break;                
                case _this.IsTextarea(fieldType):
                case _this.IsTextbox(fieldType):
                    data.StringValue = _this.GetStringValue($fieldElement);
                    break;
                case _this.IsDropdown(fieldType):
                    data.IntValue = _this.GetIntValue($fieldElement);
                    break;
                case _this.IsCheckbox(fieldType):
                    data.BooleanValue = _this.GetBoolean($fieldElement);
                    break;
                case _this.IsDateTime(fieldType):
                    var date = _this.GetDatePickerValue($fieldElement.find(".date-input"), false);
                    addTime(date, $fieldElement.find(".time-input"));
                    data.DateTimeValue = date;
                    break;
                case _this.IsMenuTextbox(fieldType):
                    var roleId = getRole($fieldElement);
                    data.Contents = getMenuTextboxValue($fieldElement, roleId);
                    break;
                default:
                    break;
            }
        }
        
        return data;
    };

    this.GetStringValue = function ($element) {
        return isJqueryObject($element) ? $.trim($element.val()) : "";
    };
    
    this.GetIntValue = function ($element) {
        var val = isJqueryObject($element) ? _this.GetStringValue($element) : "";
        return $.isNumeric(val) ? parseInt(val) : 0;
    };
    
    this.GetBoolean = function ($element) {
        var val = isJqueryObject($element) ? $element.is(":checked") : false;
        return val;
    };

    this.GetDatePickerValue = function ($dateElement, includeTime) {
        var date = null;
        
        if (isJqueryObject($dateElement)) {
            date = $dateElement.datepicker("getDate");
            
            if (date != null && !includeTime) {
                date.setHours(0, 0, 0);                
            }
        }
        
        return date;
    };

    function addTime(date, $timeElement) {
        if (isJqueryObject($timeElement) && date != null) {
            var timeArr = $timeElement.val().split(":");

            if (timeArr != null && timeArr.length > 0) {
                var hour = $.isNumeric(timeArr[0]) ? parseInt(timeArr[0]) : 0;
                var minute = (timeArr.length > 1 && $.isNumeric(timeArr[1])) ? parseInt(timeArr[1]) : 0;
                var second = (timeArr.length > 2 && $.isNumeric(timeArr[2])) ? parseInt(timeArr[2]) : 0;

                date.setHours(hour, minute, second);
            }
        }        
    }
    
    function addPadForDateTime(number) {
        var r = String(number);
        return (r.length == 1) ? ('0' + r) : r;
    }

    function getMenuTextboxValue($fieldElement, roleId) {
        var arrObjs = [];

        if (isJqueryObject($fieldElement)) {
            var $listData = $fieldElement.find(".autocomplete-area").find(".suggestion-val");

            if ($listData.length == 0 && roleId > 0) {
                arrObjs.push({ Id: 0, Role: roleId });
            }
            else
            {
                $listData.each(function (idx) {
                    var val = $(this).data("id");
                    var obj = {};
                    obj.AccessRights = $(this).data("rights");

                    if (val != null && $.trim(val) != "") {
                        val = $.trim(val);
                        obj.Role = roleId;

                        if (val.indexOf(":") > 0) {
                            var vals = val.split(":");
                            obj.Id = (vals.length > 0 && $.isNumeric(vals[0])) ? parseInt(vals[0]) : 0;
                            obj.Type = (vals.length > 1 && $.isNumeric(vals[1])) ? parseInt(vals[1]) : 0;
                        }
                        else {
                            obj.Id = $.isNumeric(val) ? parseInt(val) : 0;
                            obj.Type = 0;
                        }

                        if (obj.Id != 0)
                            arrObjs.push(obj);
                    }
                });
            }            
        }

        return arrObjs;
    }

    function getRole($fieldElement) {
        var val = 0;
        if (isJqueryObject($fieldElement)) {
            var id = $fieldElement.data("roleId");
            val = $.isNumeric(id) ? parseInt(id) : 0;
        }
        return val;
    }

    function getFieldType($fieldElement) {
        var fieldType = isJqueryObject($fieldElement) ? $fieldElement.data("fieldType") : "";
        return (fieldType == null) ? "" : fieldType;
    }

    function getFieldKey($fieldElement) {
        var fieldKey = isJqueryObject($fieldElement) ? $fieldElement.data("fieldKey") : "";
        return (fieldKey == null) ? "" : fieldKey;
    }

    function getStructureId($fieldElement) {
        var structureId = 0;
        
        if (isJqueryObject($fieldElement)) {
            var id = $fieldElement.closest("[data-structure-id]").data("structureId");
            structureId = $.isNumeric(id) ? parseInt(id) : 0;
        }

        return structureId;
    }

    function isJqueryObject($element) {
        return ($element != null && $element.length > 0);
    }

}).apply(ContentPropertyField);