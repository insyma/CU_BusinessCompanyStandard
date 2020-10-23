function setIsoDatepicker($datepicker) {
        if ($datepicker != null && $datepicker.length > 0) {
            var isoDate = $datepicker.val().split("-");

            if (isoDate != null && isoDate.length > 2) {
                var year = $.isNumeric(isoDate[0]) ? parseInt(isoDate[0]) : 0;
                var month = $.isNumeric(isoDate[1]) ? parseInt(isoDate[1]) : 0;
                var day = $.isNumeric(isoDate[2]) ? parseInt(isoDate[2]) : 0;

                if (year > 0 && month > 0 && day > 0) {
                    var date = new Date(year, month - 1, day);
                    $datepicker.datepicker("setDate", date);
                }
            }
        }
    }

function createNewTag(tagsinput, value, className, dataId) {
    var valid = true;
    $(tagsinput).children(".tagit-choice").each(function () {
        if ($(this).attr("data-id") == dataId) {
            valid = false;
            return false;
        }
    });
    if (valid == true) {
        $(tagsinput).tagit("createTag", value, className, dataId);

    }
    return true;
}


$.fn.extend({
    treed: function (o) {
        var openedClass = 'glyphicon-minus-sign';
        var closedClass = 'glyphicon-plus-sign';

        if (typeof o !== 'undefined') {
            if (typeof o.openedClass !== 'undefined') {
                openedClass = o.openedClass;
            }
            if (typeof o.closedClass !== 'undefined') {
                closedClass = o.closedClass;
            }
        }

        //initialize each of the top levels
        var tree = $(this);
        tree.addClass("tree");
        tree.find('li').has("ul").each(function () {
            var branch = $(this); //li with children ul
            branch.prepend("<i class='indicator glyphicon " + closedClass + "'></i>");
            branch.addClass('branch');
            branch.on('click', function (e) {
                if ((this.children[0] == e.target)) {
                    var icon = $(this).children('i:first');
                    icon.toggleClass(openedClass + " " + closedClass);
                    $(this).children().children().toggle();
                }
            });
            branch.children().children().toggle();
        });
        //fire event from the dynamically added icon
        tree.find('.branch .indicator').each(function () {
            $(this).on('click', function () {
                $(this).closest('li').click();
            });
        });
        //fire event to open branch if the li contains an anchor instead of text
        tree.find('.branch > a').each(function () {
            $(this).on('click', function (e) {
                $(this).closest('li').click();
                e.preventDefault();
            });
        });
        //fire event to open branch if the li contains a button instead of text
        tree.find('.branch > button').each(function () {
            $(this).on('click', function (e) {
                $(this).closest('li').click();
                e.preventDefault();
            });
        });
    }
});

//Initialization of treeviews
var list = ContentPropertyField.ContactLoginGroupTreeDataSource();

function json2htmlnode(json) {
    var i, ret = "";

    if (json.Label) {
        ret += "<li><span id='" + json.Id + "' parentId='" + json.ParentId + "' data-id='" + json.Value + "' class='treeview-item'>";
        ret += json.Label;
        ret += "</span>";
        if ((typeof json.Children === "object") && ((json.Children.length > 0))) {
            ret += "<ul>";
            for (i in json.Children) {
                ret += json2htmlnode(json.Children[i]);
            }
            ret += "</ul>";

        }
        ret += "</li>";
    }


    return ret;


}

function json2htmlgroup(list) {
    var i, ret = "";
    if (list.GroupTypeName) {
        ret += "<span class='icon-down iconbefore group-header'>";
        ret += list.GroupTypeName;
        ret += "</span>";
        ret += "<ul class='tree-view'>";
        for (var g = 0; g < list.Groups.length; g++) {
            if (list.Groups[g].ParentId == 0) {
                ret += json2htmlnode(list.Groups[g]);
            }
        }
        ret += "</ul>";
    } else {
        for (i in list) {
            ret += "<div class='group-div'>";
            ret += json2htmlgroup(list[i]);
            ret += "</div>";
        }
    }
    return ret;

}

var result = json2htmlgroup(list);
$('.include-contact').append(result);
$('.tree-view').treed();
$('.include-contact').each(function () {
    var contain = $(this);
    $(this).closest(".media-menu").find(".tagsinput ").children(".tagit-choice").each(function () {
        var dataID = $(this).attr("data-id");
        $(".treeview-item", contain).each(function () {
            if ($(this).attr("data-id") == dataID) {
                $(this).addClass("hasBefore");
            }
        });
    });
});

$(".group-header").click(function () {
    $(this).nextAll().toggle();
    $(this).toggleClass("icon-down").toggleClass("icon-up");
});

$(".list-view").children().click(function () {
    var dataId = $(this).attr("data-id");
    var label = $(this).children("span").text();
    var tagsinput = $(this).closest(".media-menu").find(".tagsinput");

    if ($(this).hasClass("hasBefore")) {
        tagsinput.tagit("removeTagById", dataId);
        $(this).removeClass("tagit-choice hasBefore");
    } else {
        createNewTag(tagsinput, label, null, dataId);
        $(this).addClass("tagit-choice hasBefore");
    }
});

$(".treeview-item").click(function () {
    var dataId = $(this).attr("data-id");
    var label = $(this).text();
    var tagsinput = $(this).closest(".media-menu").find(".tagsinput");
    if (!$(this).hasClass("hasBefore")) {
        createNewTag(tagsinput, label, null, dataId);
        $(this).addClass("hasBefore");
    } else {
        tagsinput.tagit("removeTagById", dataId);
        $(this).removeClass("hasBefore");
    }

});

$(document).ready(function () {
    console.log("JS finder");
    initBlurMandatory();
    $(".menu-icon").click(function () {
        $(".menu-icon").not(this).next(".media-menu").hide().parent().removeClass("click");
        $(this).parent().toggleClass("click");
        $(this).next(".media-menu").toggle(0, function () {
            if ($(this).is(':visible')) {
                ContentProperty.SetContentHeight($(this).outerHeight(true), $(this).parent().offset().top);
            } else {
                ContentProperty.SetContentHeight();
            }

        });
        $('html, body').animate({ scrollTop: $(this).offset().top + 100 }, 'slow');
    });

    $(".menu-icon-sub").click(function () {
        $(this).parent().toggleClass("click");
        $(this).next(".media-menu-sub").toggle();
    });

    function tagsinputInitDefault(dataRoleId, dataKey, value, dataId) {

        var tagsinput = $('div[data-role-id="' + dataRoleId + '"][data-field-key="' + dataKey + '"]').find(".tagsinput");
        if (tagsinput.children(".tagit-choice").length == 0) {
            createNewTag(tagsinput, value, null, dataId);
        }

    }

    function tagsinputInit(tagsinputthis) {
        var fieldKey = $(tagsinputthis).closest("[data-field-key]").attr("data-field-key");
        var dataSource = ContentPropertyField.GetDataSource(fieldKey);
        //console.log(fieldKey + " : ");
        //console.log(dataSource);
        var objlabel = [];
        if (dataSource) {
            //for (var i = 0; i < dataSource.length; i++) {
            //    var label = dataSource[i].Label;
            //    objlabel.push(label);
            //}
            var $this = $(tagsinputthis);
            function changeData(data) {
                for (var i = 0; i < data.length; i++) {
                    if (data[i].hasOwnProperty("Label")) {
                        data[i]["label"] = data[i]["Label"];
                        delete data[i]["Label"];
                    }

                    if (data[i].hasOwnProperty("Value")) {
                        data[i]["value"] = data[i]["Value"];
                        delete data[i]["Value"];
                    }
                }
            }

            changeData(dataSource);

            $(tagsinputthis).tagit({
                allowSpaces: true,
                tagSource: dataSource,
                caseSensitive: false,
                afterTagAdded: function (event, ui) {
                    var valid = true;
                    var valueSearch;
                    var parentUl;
                    var childSuggest;
                    var flag = 0;
                    if (!(ui.tag.hasClass("pre-added"))) {
                        var fieldKey = $(tagsinputthis).closest("[data-field-key]").attr("data-field-key");
                        var addNew = $(tagsinputthis).parent().attr("data-add-new");
                        var structureId = $(tagsinputthis).closest(".segment").attr("data-structure-id");

                        var value = ui.tag.children(".tagit-label").text();
                        var valdataId = ui.tag.attr("data-id");

                        var liDataSource = $(tagsinputthis).children(".tagit-choice");
                        if (!(valdataId)) {
                            dataSource.forEach(function (e) {
                                if (e.label) {
                                    if (value.toUpperCase() == e.label.toUpperCase()) {
                                        flag = 1;
                                        //var dataId = $(this).attr("data-id");
                                        valdataId = e.value;
                                    }
                                }


                            });
                        }

                        if (valdataId) {
                            $($this).children("li.tagit-choice").last().attr('data-id', valdataId).addClass("suggestion-val");
                            flag = 1;
                            var flaginside = 0;
                            liDataSource.each(function () {
                                if (valdataId == $(this).attr("data-id")) {
                                    flaginside = flaginside + 1;
                                    $(this).effect('highlight');
                                    //var dataId = $(this).attr("data-id");
                                    //return false;

                                }
                            });
                            if (flaginside > 1) {
                                $($this).children("li.tagit-choice").last().remove();
                                valid = false;
                            }
                            if (flaginside == 1) {
                                //console.log(ui.tag);
                                //console.log(ui);
                                //ContentProperty.InsertBaseContent(fieldKey, structureId, value);
                                var ulSuggest;
                                if ($($this).hasClass("inside-menu")) {
                                    valid = createNewTag($($this).closest("[data-field-key]").children(".tagsinput"), value, "suggestion-val", valdataId);
                                    parentUl = $($this).parent().parent();
                                    valueSearch = parentUl.find(".search-input-tag").val();
                                    childSuggest = parentUl.find(".tagsinput-suggest");
                                    if (childSuggest.length > 0) {
                                        tagsinputsuggestInit(childSuggest, valueSearch);
                                    }
                                    ulSuggest = parentUl.find(".search-result");
                                    $(ulSuggest).find(".tagit-choice,.treeview-item").each(function () {
                                        if ($(this).attr("data-id") == valdataId) {
                                            $(this).addClass("hasBefore");
                                        }
                                    });

                                    $($this).closest("[data-field-key]").children(".tagsinput").tagit("removeTagById", value);

                                } else {
                                    parentUl = $($this).closest("[data-field-key]").children(".menu-con");
                                    valid = createNewTag(parentUl.find(".tagsinput"), value, "suggestion-val", valdataId);
                                    valueSearch = parentUl.find(".search-input-tag").val();
                                    childSuggest = parentUl.find(".tagsinput-suggest");
                                    if (childSuggest.length > 0) {
                                        tagsinputsuggestInit(childSuggest, valueSearch);
                                    }
                                    ulSuggest = parentUl.find(".search-result");
                                    $(ulSuggest).find(".tagit-choice,.treeview-item").each(function () {
                                        if ($(this).attr("data-id") == valdataId) {
                                            $(this).addClass("hasBefore");
                                        }
                                    });
                                }
                                //}
                                //});
                            }

                        }
                        if (flag == 0) {
                            if (!(ContentPropertyField.IsAuthor(fieldKey) || ContentPropertyField.IsPublisher(fieldKey) || ContentPropertyField.IsResponsible(fieldKey) || ContentPropertyField.IsRightsUserGroup(fieldKey) || ContentPropertyField.IsRightsUserGroupRoleBased(fieldKey) || ContentPropertyField.IsSettingsAllowFilterBy(fieldKey))) {
                                $('#confirm-save-modal').modal({ backdrop: 'static', keyboard: false });
                                $("#new-value-label").text(value);
                                $('#confirm-save-modal').modal('show');
                                $('#save-change').off();
                                $('#save-change').on('click', function (e) {

                                    if (!(ui.tag.hasClass("pre-added"))) {
                                        if (addNew == "False") {
                                            $('#confirm-save-modal').modal('hide');
                                            $('#data-addnew-modal').modal({ backdrop: 'static', keyboard: false });
                                            $('#data-addnew-modal').modal('show');
                                            $($this).children("li.tagit-choice").last().remove();

                                        } else {
                                            // save
                                            var dataId = ContentProperty.InsertBaseContent(fieldKey, structureId, value);

                                            $($this).children("li.tagit-choice").last().attr('data-id', dataId).addClass("suggestion-val");
                                            //tagsinputInitAutocomplete($($this));
                                            tagsinputInit($($this));
                                            if ($($this).hasClass("inside-menu")) {

                                                tagsinputInit($($this).closest("[data-field-key]").children(".tagsinput"));
                                                valid = createNewTag($($this).closest("[data-field-key]").children(".tagsinput"), value, "suggestion-val", dataId);
                                                parentUl = $($this).parent().parent();
                                                valueSearch = parentUl.find(".search-input-tag").val();
                                                childSuggest = parentUl.find(".tagsinput-suggest");
                                                if (childSuggest.length > 0) {
                                                    tagsinputsuggestInit(childSuggest, valueSearch);
                                                } else {
                                                    var listView = parentUl.find(".group-div").eq(0).children(".list-view");
                                                    listView.append("<li data-id=" + dataId + " class='tagit-choice hasBefore'><span>" + value + "</span></li>");
                                                    listView.children().last().click(function () {
                                                        var dataId = $(this).attr("data-id");
                                                        var label = $(this).children("span").text();
                                                        var tagsinput = $(this).closest(".media-menu").find(".tagsinput");
                                                        createNewTag(tagsinput, label, null, dataId);
                                                        $(this).addClass("tagit-choice hasBefore");
                                                    });
                                                }
                                            } else {
                                                parentUl = $($this).closest("[data-field-key]").children(".menu-con");
                                                tagsinputInit(parentUl.find(".tagsinput"));
                                                valid = createNewTag(parentUl.find(".tagsinput"), value, "suggestion-val", dataId);

                                                valueSearch = parentUl.find(".search-input-tag").val();
                                                childSuggest = parentUl.find(".tagsinput-suggest");
                                                if (childSuggest.length > 0) {
                                                    tagsinputsuggestInit(childSuggest, valueSearch);
                                                } else {
                                                    var listView = parentUl.find(".group-div").eq(0).children(".list-view");
                                                    listView.append("<li data-id=" + dataId + " class='tagit-choice hasBefore'><span>" + value + "</span></li>");
                                                    listView.children().last().click(function () {
                                                        var dataId = $(this).attr("data-id");
                                                        var label = $(this).children("span").text();
                                                        var tagsinput = $(this).closest(".media-menu").find(".tagsinput");
                                                        createNewTag(tagsinput, label, null, dataId);
                                                        $(this).addClass("tagit-choice hasBefore");
                                                    });
                                                }
                                            }

                                            $($this).children("li.tagit-choice").last().attr('data-id', dataId).addClass("suggestion-val");
                                            $('#confirm-save-modal').modal('hide');
                                        }
                                    }
                                });
                                $('#close-button, .close').off();
                                $('#close-button, .close').on('click', function (e) {
                                    $($this).children("li.tagit-choice").last().remove();
                                    //valid = false;
                                });
                            } else {
                                $($this).children("li.tagit-choice").last().remove();
                                //valid = false;
                            }

                        }

                    }
                    return valid;
                },
                afterTagRemoved: function (event, ui) {
                    // do something special
                    //console.log(ui.tag);
                    var value = $(ui.tag).attr("data-id");
                    if ($($this).hasClass("inside-menu")) {
                        var ulSuggest = $($this).parent().parent().find(".search-result");
                        $(ulSuggest).find(".tagit-choice,.treeview-item").each(function () {
                            if ($(this).attr("data-id") == value) {
                                $(this).removeClass("hasBefore");
                            }
                        });

                        $($this).closest("[data-field-key]").children(".tagsinput").tagit("removeTagById", value);


                    } else {
                        var ulSuggest = $($this).closest("[data-field-key]").children(".menu-con").find(".search-result");
                        $(ulSuggest).find(".tagit-choice,.treeview-item").each(function () {
                            if ($(this).attr("data-id") == value) {
                                $(this).removeClass("hasBefore");
                            }
                        });
                        $($this).closest("[data-field-key]").children(".menu-con").find(".tagsinput").tagit("removeTagById", value);

                    }
                }
            });
            // validation blur
            $(tagsinputthis).data("ui-tagit").tagInput.blur(function () {
                var parent = $(this).closest("[data-field-type]");
                var message = $(parent).children(".mandatory-menu-textbox");
                if ($(message).length > 0) {
                    if ($(parent).find(".tagsinput").children(".tagit-choice").length == 0) {
                        $(message).show();

                    } else {
                        $(message).hide();
                    }
                }

            });
        }
    }

    function tagsinputInitAutocomplete(element) {
        var fieldKey = $(element).closest("[data-field-key]").attr("data-field-key");
        var dataSource = ContentPropertyField.GetDataSource(fieldKey);
        if (dataSource) {
            function changeData(data) {
                for (var i = 0; i < data.length; i++) {
                    if (data[i].hasOwnProperty("Label")) {
                        data[i]["label"] = data[i]["Label"];
                        delete data[i]["Label"];
                    }

                    if (data[i].hasOwnProperty("Value")) {
                        data[i]["value"] = data[i]["Value"];
                        delete data[i]["Value"];
                    }
                }
            }

            changeData(dataSource);

            $(element).tagit({

                tagSource: dataSource

            });
        }
    }
    $(".tagsinput").each(function () {
        tagsinputInit(this);
    });

    // function will be define in Structures.cshtml (server-side)
    if (typeof (setAuthorRole) === "function")
        setAuthorRole();

    function getObjects(obj, key, val) {
        var objects = [];
        for (var i in obj) {
            if (!obj.hasOwnProperty(i)) continue;
            if (typeof obj[i] == 'object') {
                objects = objects.concat(getObjects(obj[i], key, val));
            } else {
                val = val.toUpperCase();
                if (obj[key]) {
                    var valObj = obj[key].toUpperCase();
                    if (i == key && valObj.indexOf(val) > -1) {
                        objects.push(obj);
                    }
                }

            }
        }
        return objects;
    }

    function tagsinputsuggestInit(tagsinputsuggestthis, valueSearch) {
        var fieldKey = $(tagsinputsuggestthis).closest("[data-field-key]").attr("data-field-key");
        var dataSource = ContentPropertyField.GetDataSource(fieldKey);

        function changeData(data) {
            if (data) {
                for (var i = 0; i < data.length; i++) {
                    if (data[i].hasOwnProperty("Label")) {
                        data[i]["label"] = data[i]["Label"];
                        delete data[i]["Label"];
                    }

                    if (data[i].hasOwnProperty("Value")) {
                        data[i]["value"] = data[i]["Value"];
                        delete data[i]["Value"];
                    }
                }
            }
        }

        changeData(dataSource);

        //$(tagsinputsuggestthis).tagit({
        //    allowSpaces: true,
        //    readOnly: true,
        //    onTagClicked: function(event, ui) {
        //        var mediaMenu = tagsinputSuggest.closest(".media-menu");
        //        var tagsinput = mediaMenu.find(".tagsinput");
        //        var labelValue = ui.tag.find(".tagit-label").text();
        //        if ($(ui.tag).hasClass("hasBefore")) {
        //            tagsinput.tagit("removeTagById", ui.tag.attr("data-id"));
        //        } else {
        //            createNewTag(tagsinput, labelValue, null, ui.tag.attr("data-id"));
        //        }

        //    }
        //});

        //tagsinputSuggestf.children().last().click(function() {
        //    var dataId = $(this).attr("data-id");
        //    var label = $(this).children("span").text();
        //    var tagsinput = $(this).closest(".media-menu").find(".tagsinput");
        //    createNewTag(tagsinput, label, null, dataId);
        //    $(this).addClass("tagit-choice hasBefore");
        //});
        // $(tagsinputsuggestthis).tagit("removeAll");
        $(tagsinputsuggestthis).children().remove();
        var mediaMenu = $(tagsinputsuggestthis).closest(".media-menu");
        var tagsinput = mediaMenu.find(".tagsinput");
        if (valueSearch) {
            var obj = getObjects(dataSource, 'label', valueSearch);
            if (obj) {
                dataSource = obj;
            }
        }
        if (dataSource) {
            for (var i = 0; i < dataSource.length; i++) {
                var label = dataSource[i].label;
                var classExist = null;
                $(tagsinput).find(".tagit-choice").each(function () {
                    if ($(this).attr("data-id") == dataSource[i].value) {
                        classExist = "tagit-choice hasBefore";
                    }
                });
                //createNewTag($(tagsinputsuggestthis), label, classExist, dataSource[i].value);
                $(tagsinputsuggestthis).append("<li data-id=" + dataSource[i].value + " class='" + classExist + "'><span>" + label + "</span></li>");
                $(tagsinputsuggestthis).children().last().click(function () {
                    var dataId = $(this).attr("data-id");
                    var label = $(this).children("span").text();
                    var tagsinput = $(this).closest(".media-menu").find(".tagsinput");
                    if ($(this).hasClass("hasBefore")) {
                        tagsinput.tagit("removeTagById", dataId);
                        $(this).removeClass("tagit-choice hasBefore");
                    } else {
                        createNewTag(tagsinput, label, null, dataId);
                        $(this).addClass("tagit-choice hasBefore");
                    }
                });
            }
        }
    }

    $(".tagsinput-suggest").each(function () {
        tagsinputsuggestInit(this);
    });

    function searchListView(objf, tagsinputSuggestf, tagsinputf) {
        if (objf) {
            for (var i = 0; i < objf.length; i++) {
                var label = objf[i].label;
                var classExist = null;
                $(tagsinputf).find(".tagit-label").each(function () {
                    if ($(this).text() == label) {
                        classExist = "tagit-choice hasBefore";
                    }
                });
                //<li data-id="2-1" class=""><span>Technisches Facility Management</span></li>
                //if (tagsinputSuggestf.hasClass("list-view")) {
                tagsinputSuggestf.append("<li data-id=" + objf[i].value + " class='" + classExist + "'><span>" + label + "</span></li>");
                tagsinputSuggestf.children().last().click(function () {
                    var dataId = $(this).attr("data-id");
                    var label = $(this).children("span").text();
                    var tagsinput = $(this).closest(".media-menu").find(".tagsinput");
                    createNewTag(tagsinput, label, null, dataId);
                    $(this).addClass("tagit-choice hasBefore");
                });

                //} else {
                //    createNewTag(tagsinputSuggestf, label, classExist, objf[i].value);
                //}
            }
        }
    }
    $(".search-input-tag").each(function () {

        $(this).keyup(function () {
            if (($(this).val().length >= 0) || ($(this).val().length == 0)) {

                var searchInputTag = $(this);
                var value = $(this).val();
                var mediaMenu = searchInputTag.closest(".media-menu");
                var tagsinputSuggest = mediaMenu.find(".tagsinput-suggest");
                var tagsinput = mediaMenu.find(".tagsinput");
                //tagsinputSuggest.tagit("removeAll");
                var fieldKey;
                var dataSource;
                var obj;
                if (tagsinputSuggest.length == 0) {
                    tagsinputSuggest = mediaMenu.find(".origin-content").children(".list-view");
                    tagsinputSuggest.children().remove();
                    dataSource = ContentPropertyField.GetOriginContentDataSource();
                    obj = getObjects(dataSource, 'label', value);
                    searchListView(obj, tagsinputSuggest, tagsinput);
                    tagsinputSuggest = mediaMenu.find(".contact").children(".list-view");
                    tagsinputSuggest.children().remove();
                    dataSource = ContentPropertyField.ContactDataSource();
                    obj = getObjects(dataSource, 'label', value);
                    searchListView(obj, tagsinputSuggest, tagsinput);
                } else {
                    fieldKey = $(this).closest("[data-field-key]").attr("data-field-key");
                    dataSource = ContentPropertyField.GetDataSource(fieldKey);
                    obj = getObjects(dataSource, 'label', value); //console.log(obj);
                    tagsinputSuggest.children().remove();
                    searchListView(obj, tagsinputSuggest, tagsinput);
                }
                //console.log(dataSource);



                var treeView = mediaMenu.find(".tree-view");

                function findParentTreeView(idTree, treeViewThis) {
                    var parents = [];
                    var thisSpan;
                    $(".treeview-item", treeViewThis).each(function () {
                        if ($(this).attr("data-id") == idTree) {
                            thisSpan = this;
                        }
                    });
                    var parentDataId = "";
                    if ($(thisSpan).attr("parentid")) {
                        parentDataId = $(thisSpan).parent("li").parent("ul").prev("span").attr("data-id");
                        if (parentDataId) {
                            parents.push(parentDataId);
                        }

                    }
                    if ($(thisSpan).attr("parentid")) {
                        var parentsNext = findParentTreeView(parentDataId, treeViewThis);
                        if (parentsNext) {
                            var dataParentsNext = parentsNext[0];
                            if (dataParentsNext) {
                                parents.push(dataParentsNext);
                            }
                        }


                    }
                    if (parents.length > 0) {
                        return parents;
                    }

                }
                $(treeView).each(function () {
                    var objValTree = [];
                    var treeViewThis = $(this);
                    var parents = [];
                    var searchResults = [];
                    $(".treeview-item", this).each(function () {
                        var valTree = $(this).text().toUpperCase();
                        var idTree = $(this).attr("data-id");//text().toUpperCase();
                        var id = $(this).attr("id");//text().toUpperCase();
                        var parentId = $(this).attr("parentId");//text().toUpperCase();

                        var valuePress = value.toUpperCase();
                        if (valTree.indexOf(valuePress) > -1) {
                            var parentChild = findParentTreeView(idTree, treeViewThis);
                            if (parentChild) {
                                for (var i = 0; i < parentChild.length; i++) {

                                    parents.push(parentChild[i]);
                                }

                            }
                            searchResults.push(idTree);
                            //console.log(parents);
                            objValTree.push({ "value": idTree, "label": valTree, "id": id, "parentId": parentId });
                        }
                    });
                    //console.log(parents);
                    var uniqueparents = [];
                    $.each(parents, function (i, el) {
                        if ($.inArray(el, uniqueparents) === -1) uniqueparents.push(el);
                    });
                    console.log(uniqueparents);
                    console.log(searchResults);

                    $(".treeview-item", this).parent().show();
                    $(".treeview-item", this).removeClass("haveSearch searchResults last-li-tree");
                    $(".indicator", this).hide();
                    for (var i = 0; i < uniqueparents.length; i++) {
                        $(".treeview-item", this).each(function () {
                            var idTree = $(this).attr("data-id");//text().toUpperCase();
                            if (idTree == uniqueparents[i]) {
                                $(this).addClass("haveSearch");
                            }

                        });
                    }
                    for (i = 0; i < searchResults.length; i++) {
                        $(".treeview-item", this).each(function () {
                            var idTree = $(this).attr("data-id");//text().toUpperCase();
                            if (idTree == searchResults[i]) {
                                $(this).addClass("haveSearch searchResults");
                            }
                        });
                    }
                    $(".treeview-item", this).each(function () {
                        if (!$(this).hasClass("haveSearch")) {
                            $(this).parent().hide();
                        }
                    });
                    $('.tree li:visible:last').addClass("last-li-tree");

                });
                //console.log(objValTree);

            }

        });
    });
    //init date
    var insCalendar = new InsDatepicker(null);
    insCalendar.InitDatepickerByBrowserRegion("date-input", "time-input");

    // check structure problem
    $('[data-structure-id]').each(function () {
        console.log("structureId: " + $(this).data('structureId'));
        var dataIds = "dataIds: ";
        $(this).find('[data-rights]').each(function () {
            dataIds += $(this).data('id') + ', ';
        });

        console.log(dataIds);
    });
});
