
var ContentProperty = {};

(function () {
    var _this = this;
    var parent_url;

    this.$Elements = {};

    this.Settings = {};

    /******************** public functions ********************/
    this.Init = function () {
        initElements();
        initSettings();
    };

    this.ShowHideContent = function (isShow) {
        if (isShow) {
            _this.$Elements.PartAction.show(5,function() {
                _this.$Elements.PartContent.show(5,function() {
                    _this.SetContentHeight();
                });
            });
        }
        else {
            _this.$Elements.PartAction.hide(5,function() {
                _this.$Elements.PartContent.hide(5,function() {
                    _this.SetContentHeight();
                });
            });
        }
    };

    this.CheckShowHidePendingArchiveStructure = function () {
        var archiveElement = $('[data-field-key=CoFi_DateArchive]');
        if ($(archiveElement).length > 0) {
            var field = ContentPropertyField.GetDataField(archiveElement);
            if (field && Date.parse(field.DateTimeValue)) {
                // Show Archive structure
                $('[data-field-key$=_Pending]').closest('[data-structure-id]').show();
            } else {
                $('[data-field-key$=_Pending]').closest('[data-structure-id]').hide();
            }
        }
    };

    this.DateArchiveEvents = function () {
        var archiveElement = $("input.date-input", $('[data-field-key=CoFi_DateArchive]'));

        // Trigger on change in: Scripts\ins-lib\insDatepicker.js -> InitDatepickerByBrowserRegion -> onSelect -> $selector.change();
        $(archiveElement).on("change", function () {
            ContentProperty.CheckShowHidePendingArchiveStructure();
        });
    };

    this.LoadContents = function () {
        var self = this;

        var command = {};
        command.ClientId = _this.Settings.ClientId;
        command.PropertyBasicId = _this.Settings.PropertyBasicId;
        command.LanguageId = _this.Settings.LanguageId;
        command.ObjId = _this.Settings.ObjId;
        command.ObjParentId = _this.Settings.ObjParentId;
        command.ObjWebId = _this.Settings.ObjWebId;
        command.IsSelectionDefinition = _this.Settings.IsSelectionDefinition;
        command.ParentPageId = _this.Settings.ParentPageId;
        command.ContactId = _this.Settings.ContactId;
        command.ClassId = _this.Settings.ClassId;

        var url = _this.Settings.AppUrl + "Home/LoadStructures";

        $.ajax({
            async: false,
            type: 'POST',
            url: url,
            data: JSON.stringify(command),
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                ContentProperty.ShowHideContent(true);
                _this.$Elements.PartContent.empty().append(data);
                //setHeightCon();
                showHideFieldsBySwitchElements();
                bindSwitchElementEvents();

                if (_this.Settings.IsIntranetEnvironment) {
                    $("input[type='radio'], select, .uniform").uniform();

                    self.postLoadContentMessage("contentLoaded");
                }

                _this.DateArchiveEvents();
                _this.CheckShowHidePendingArchiveStructure();

            },
            error: function (xhr, status, error) {
                console.log("Load contents error");
            }
        });
    };

    this.InsertBaseContent = function (fieldKey, structureId, label) {
        var newId = "";
        var url = _this.Settings.AppUrl + "Content/InsertBaseContent";
        var data = {};
        data.FieldKey = fieldKey;
        data.ClientId = _this.Settings.ClientId;
        data.ObjWebId = _this.Settings.ObjWebId;
        data.ObjPageId = _this.Settings.ObjId;
        data.Name = label;
        data.StructureId = structureId;
        data.LanguageId = _this.Settings.LanguageId;
        data.IsSelectionDefinition = _this.Settings.IsSelectionDefinition;

        InsAjax.Post(
            url,
            data,
            function (result, context) {
                if (result.IsSuccess) {
                    newId = result.SingleValue;

                    var dataSource = ContentPropertyField.IsContentOrigin(fieldKey)? ContentPropertyField.GetOriginContentDataSource() : ContentPropertyField.GetDataSource(fieldKey);
                    if (dataSource != null) {
                        var items = jQuery.grep(dataSource, function (n, i) { return (n.Value == newId); });
                        if (items == null || items.length <= 0) {
                            var obj = {
                                Label: label,
                                Value: newId
                            };

                            dataSource.push(obj);
                        }
                    }
                }
            },
            function (error, context) {
                console.log("Save base content error");
            }, false
        );

        return newId;
    };

    this.SaveContents = function () {
        var fields = [];

        _this.$Elements.ContentProperties.find("[data-field-key]").each(function () {
            var $element = $(this);
            var field = ContentPropertyField.GetDataField($element);
            fields.push(field);
        });

        var command = {
            ClientId: _this.Settings.ClientId,
            ObjWebId: _this.Settings.ObjWebId,
            ObjId: _this.Settings.ObjId,
            ObjPageId: _this.Settings.ObjId,
            LanguageId: _this.Settings.LanguageId,
            IsSelectionDefinition: _this.Settings.IsSelectionDefinition,
            Fields: fields,
            ClassId: _this.Settings.ClassId,
            ParentPageId: _this.Settings.ParentPageId
        };

        var url = _this.Settings.AppUrl + "Content/SaveProperties";
        InsAjax.Post(
            url,
            command,
            function (result, context) {
                if (result.IsSuccess) {
                    //alert("Data saved successfully");
                    //$('#data-saved .modal-body p').text("Data saved successfully.");
                    $('#data-saved').modal('show');

                    ContentProperty.CheckShowHidePendingArchiveStructure();

                    postSaveContentMessage();
                }
            },
            function (error, context) {
                console.log("Save properties error");
            }, false
        );
    };

    this.SetContentHeight = function(menuHeight, menuOffset) {
        var parent_urlnotck;
        if ($.browser.msie && parseInt($.browser.version, 10) === 7) {
            var str = document.location.href;
            var n = str.search("&prurl=");
        } else {
            parent_urlnotck = decodeURIComponent(document.location.hash.replace(/^#/, ''));
        }

        if (parent_urlnotck) {
            parent_url = parent_urlnotck;
        } else {
            parent_url = $.jStorage.get("parentURLck");
        }

        $.urlParam = function(name) {
            var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(parent_url);
            if (results == null) {
                return null;
            } else {
                return results[1] || 0;
            }
        }

        if (!(menuHeight > 0)) {
            menuHeight = 0;
        } else {
            if ($('body').outerHeight(true) < (menuOffset + menuHeight)) {
                menuHeight = (menuOffset + menuHeight) - $('body').outerHeight(true) + 100;
            } else {
                menuHeight = 0;
            }
        }

        function setHeight() {
            $.postMessage({ if_height: $('body').outerHeight(true) + menuHeight, parent: $.urlParam('data-objid') }, parent_url, parent);
        };

        // Now that the DOM has been set up (and the height should be set) invoke setHeight.
        setHeight();

        $.jStorage.set("parentURLck", parent_url);
    };

    /******************** private functions ********************/
    function isJqueryObject($element) {
        return ($element != null && $element.length > 0);
    }

    function initElements() {
        var $contentProperties = $(".content-properties");

        _this.$Elements.ContentProperties = $contentProperties;
        _this.$Elements.PartAction = $contentProperties.find(".part-action");
        _this.$Elements.PartHeader = $contentProperties.find(".part-header");
        _this.$Elements.PartContent = $contentProperties.find(".part-content");

        _this.$Elements.SaveContent = _this.$Elements.PartAction.find(".icon-save");
        _this.$Elements.CancelContent = _this.$Elements.PartAction.find(".icon-cancel");
    }

    function initSettings() {

        _this.Settings.AppUrl = app_url;

        var objId = _this.$Elements.ContentProperties.find("#hidObjId_ContentProp").val();
        var propertyBasicId = _this.$Elements.ContentProperties.find("#hidPropertyBasicId_ContentProp").val();
        var languageId = _this.$Elements.ContentProperties.find("#hidLanguageId_ContentProp").val();
        var clientId = _this.$Elements.ContentProperties.find("#hidClientId_ContentProp").val();
        var objWebId = _this.$Elements.ContentProperties.find("#hidObjWebId_ContentProp").val();
        var objParentId = _this.$Elements.ContentProperties.find("#hidObjParentId_ContentProp").val();
        var isSelectionDef = _this.$Elements.ContentProperties.find("#hidIsSelectionDefinition_ContentProp").val();
        var classId = _this.$Elements.ContentProperties.find("#hidClassId_ContentProp").val();
        var isIntranet = _this.$Elements.ContentProperties.find("#hidIsIntranetEnvironment_ContentProp").val();
        var parentPageId = _this.$Elements.ContentProperties.find("#hidParentPageId_ContentProp").val();
        var contactId = _this.$Elements.ContentProperties.find("#hidContactId_ContentProp").val();

        _this.Settings.ObjId = (objId != null && $.isNumeric(objId)) ? parseInt(objId) : 0;
        _this.Settings.PropertyBasicId = (propertyBasicId != null && $.isNumeric(propertyBasicId)) ? parseInt(propertyBasicId) : 0;
        _this.Settings.LanguageId = (languageId != null && $.isNumeric(languageId)) ? parseInt(languageId) : 0;
        _this.Settings.ClientId = (clientId != null && $.isNumeric(clientId)) ? parseInt(clientId) : 0;
        _this.Settings.ObjWebId = (objWebId != null && $.isNumeric(objWebId)) ? parseInt(objWebId) : 0;
        _this.Settings.ObjParentId = (objParentId != null && $.isNumeric(objParentId)) ? parseInt(objParentId) : 0;
        _this.Settings.IsSelectionDefinition = (isSelectionDef != null && isSelectionDef.toLowerCase() == "true") ? true : false;
        _this.Settings.ClassId = (classId != null && $.isNumeric(classId)) ? parseInt(classId) : 0;
        _this.Settings.IsIntranetEnvironment = (isIntranet != null && isIntranet.toLowerCase() == "true") ? true : false;
        _this.Settings.ParentPageId = (parentPageId != null && $.isNumeric(parentPageId)) ? parseInt(parentPageId) : 0;
        _this.Settings.ContactId = (contactId != null && $.isNumeric(contactId)) ? parseInt(contactId) : 0;
    }

    function getSwitchDeleteElement() {
        return _this.$Elements.ContentProperties.find("input[data-field-key='CoFi_SwitchDelete']");
    }

    function getDateDeleteElement() {
        return _this.$Elements.ContentProperties.find("div[data-field-key='CoFi_DateDelete']");
    }

    function getSwitchArchiveElement() {
        return _this.$Elements.ContentProperties.find("input[data-field-key='CoFi_SwitchArchive']");
    }

    function getVersionElement() {
        return _this.$Elements.ContentProperties.find("input[data-field-key='CoFi_Version']");
    }

    function showHideDateDelete () {
        var $switchDelete = getSwitchDeleteElement();
        var $dateDelete = getDateDeleteElement();

        if (isJqueryObject($switchDelete) && isJqueryObject($dateDelete)) {
            if ($switchDelete.is(":checked"))
                $dateDelete.show();
            else
                $dateDelete.hide();
        }
    };

    function showHideVersion() {
        var $switchArchive = getSwitchArchiveElement();
        var $version = getVersionElement();

        if (isJqueryObject($switchArchive) && isJqueryObject($version)) {
            var $div = $version.closest(".input-text");

            if ($switchArchive.is(":checked"))
                $div.show();
            else
                $div.hide();
        }
    };

    function showHideFieldsBySwitchElements() {
        showHideDateDelete();
        showHideVersion();
    }

    function bindSwitchElementEvents() {

        getSwitchDeleteElement().off("click").on("click", function () {
            showHideDateDelete();
        });

        getSwitchArchiveElement().off("click").on("click", function () {
            showHideVersion();
        });
    };

    this.postLoadContentMessage = function(command) {
        var parent = getParentWin();

        if (parent != null) {
            var height = _this.$Elements.ContentProperties.height();

            var data = {
                command: command,
                data: {
                    height: height
                }
            };
            parent.postMessage(JSON.stringify(data), "*");
        }
    };

    function postSaveContentMessage() {
        var parent = getParentWin();

        if (parent != null) {
            //var ifrName = $.QueryString["ifrName"];

            var data = {
                command: "contentSaved",
                data: {
                    //ifrName: ifrName
                }
            };
            parent.postMessage(JSON.stringify(data), "*");
        }
    }

    function getParentWin() {
        return window.dialogArguments || opener || parent || top;
    }

}).apply(ContentProperty);

/********************************************************** Events **********************************************************/

$(document).ready(function () {
    ContentProperty.Init();

    console.log('load');
    ContentProperty.postLoadContentMessage('loadStructure');

    ContentProperty.$Elements.PartHeader.off("click").on("click", function () {

        if (ContentProperty.$Elements.PartContent.children().length > 0) {
            var isVisible = ContentProperty.$Elements.PartContent.is(":visible");

            ContentProperty.ShowHideContent(!isVisible);

        }
        else {
            ContentProperty.LoadContents();
        }
    });

    ContentProperty.$Elements.CancelContent.off("click").on("click", function () {
        ContentProperty.ShowHideContent(false);
    });

    ContentProperty.$Elements.SaveContent.off("click").on("click", function () {
        var valid = validationMandatory();
        if(valid === true){
            ContentProperty.SaveContents();
        }else{
            $('#data-saved .modal-body p').text(labels.dataInvalidMessage);
            $('#data-saved').modal('show');
        }
    });

    //$("body").on("change", $("input.hasDatepicker", $('[data-field-key=CoFi_DateArchive]')), function () {
    //    ContentProperty.CheckShowHidePendingArchiveStructure();
    //});

    $(window).load(function () {        
        ContentProperty.SetContentHeight();
    });
});
