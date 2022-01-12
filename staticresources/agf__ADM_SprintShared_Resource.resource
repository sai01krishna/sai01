window.ADM_SprintShared_Resource = (function() {

    var isWorkItemVisible = function(work, filters) {
        var workItemVisible = true;
        var sprintWorkRecord = work.m_story;

        if (Object.keys(filters).length > 0) {
            for (var key in filters) {
                var workFieldValue;

                if (key.indexOf('.') != -1) {
                    var keys = key.split('.');
                    if (sprintWorkRecord[keys[0]] != null) {
                        workFieldValue = sprintWorkRecord[keys[0]][keys[1]];
                    } else {
                        workItemVisible = false;
                    }
                } else {
                    workFieldValue = sprintWorkRecord[key];
                }

                if (workItemVisible) {
                    if (key == "theme") {
                        if (sprintWorkRecord.Theme_Assignments__r != null && sprintWorkRecord.Theme_Assignments__r.totalSize > 0) {
                            var workThemes = sprintWorkRecord.Theme_Assignments__r.records;
                            var workContainsFilterTheme = false;

                            var themesLen = workThemes.length;

                            for (var t=0 ; t < themesLen ; t++) {
                                if (!workContainsFilterTheme) {
                                    if (workThemes[t].Theme__r != null && ADM_SprintShared_Resource.valIsInFilterArr(workThemes[t].Theme__r.Id, filters[key])) {
                                        workContainsFilterTheme = true;
                                    }
                                }
                            }

                            if (workContainsFilterTheme) {
                                workItemVisible = true;
                            } else {
                                workItemVisible = false;
                            }
                        } else {
                            workItemVisible = false;
                        }
                    } else if (key == 'users') {
                        workItemVisible = atLeastOneUserInFilter(work, filters[key]);
                    } else if (ADM_SprintShared_Resource.valIsInFilterArr(workFieldValue, filters[key])) {
                        workItemVisible = true;
                    } else {
                        workItemVisible = false;
                    }
                }
            }
        }

        return workItemVisible;
    }

    var isString = function(val) {
        return typeof val === 'string';
    }

    var isObj = function(val) {
        return typeof val === 'object';
    }

    var isArr = function(val) {
        return Array.isArray(val);
    }

    var isBool = function(val) {
        return typeof val === 'boolean';
    }

    var valIsInFilterArr = function(val, filterArr) {
        return typeof val != null && filterArr && ADM_SprintShared_Resource.getIdxInFilterArr(val, filterArr) !== -1;
    }

    var getIdxInFilterArr = function(value, filterArr) {
        for (var i = 0; i < filterArr.length; i++) {
            if (ADM_SprintShared_Resource.matchesFilterValue(value, filterArr[i])) {
                return i;
            }
        }

        return -1;
    }

    var matchesFilterValue = function(value, filterValue) {
        // for backwords compatibility:
        // We used to just store "value", now we store {val: 'value', label: 'label'},
        // so we need to check it both ways
        return ADM_SprintShared_Resource.isObj(filterValue) ?
            filterValue.val === value
            : filterValue === value
    }

    var createUserMap = function(works) {
        // takes in works array & returns a map of users with the Id as the key and the val as the user object.
        var userMap = {};

        if (!works || !ADM_SprintShared_Resource.isArr(works)) {
            return userMap;
        }

        var updateUserMap = function(user, userMap) {
            if (!user || !user.Id) {
                return userMap;
            }
            if (!userMap[user.Id]) {
                userMap[user.Id] = user;
            }
            return userMap
        };

        works.forEach(function(work) {
            work.m_plannedTasks.tasks.forEach(function(task) {
                userMap = updateUserMap(task.Assigned_To__r, userMap);
            })
            work.m_inProgressTasks.tasks.forEach(function(task) {
                userMap = updateUserMap(task.Assigned_To__r, userMap);
            })
            work.m_completedTasks.tasks.forEach(function(task) {
                userMap = updateUserMap(task.Assigned_To__r, userMap);
            })
            if (work.m_story && work.m_story.Assignee__r) {
                userMap = updateUserMap(work.m_story.Assignee__r, userMap);
            }
            if (work.m_story && work.m_story.QA_Engineer__r) {
                userMap = updateUserMap(work.m_story.QA_Engineer__r, userMap);
            }
        })

        return userMap;
    };

    var getUsersForFiltering = function(works) {
        // takes in works array & returns sorted users.
        var _helper = this;
        if (!works || !ADM_SprintShared_Resource.isArr(works)) {
            return;
        }
        var userMap = createUserMap(works);

        var addUserToMap = function(users, userId) {
            return users.concat(userMap[userId])
        };

        var sortUsersByName = function(a, b) {
            return a.Name.toLowerCase().localeCompare(b.Name.toLowerCase())
        };

        return Object.keys(userMap)
            .reduce(addUserToMap, [])
            .sort(sortUsersByName)
    }

    var getCurrTeamFilters = function(sprintData) {
        return sprintData
            && sprintData.sprintInfo
            && sprintData.sprintInfo.Scrum_Team__c
            && sprintData.wallPreferences
            && sprintData.wallPreferences.teams
            && sprintData.wallPreferences.teams[sprintData.sprintInfo.Scrum_Team__c]
            && sprintData.wallPreferences.teams[sprintData.sprintInfo.Scrum_Team__c].filters
                ? sprintData.wallPreferences.teams[sprintData.sprintInfo.Scrum_Team__c].filters
                : {}
    }

    var getInitials = function(name) {
        if (!name) {
            return '';
        }
        var lastSpaceIdx = name.lastIndexOf(' ');
        // if there's no space in the name, we'll just use the first letter of the first name.
        if (lastSpaceIdx === -1) {
            return name[0];
        }
        var firstInitial = name.slice(0, lastSpaceIdx)[0];
        var lastInitial = name.slice(lastSpaceIdx + 1, name.length)[0]
        return firstInitial + lastInitial;
    }

    var atLeastOneUserInFilter = function(work, filter) {
        var users = getUsersForFiltering([work]);
        for (var i = 0, len = users.length ; i < len ; i++) {
            for (var j = 0, jLen = filter.length ; j < jLen ; j++) {
                if (users[i].Id === filter[j].val) {
                    return true;
                }
            }
        }
        return false;
    }

    // you may only be able to use this if you register the event in the component youre calling it from
    var showSpinner = function() {
        var showSpinner = $A.get("e.agf:ADM_Event_Show_Spinner");
        if (showSpinner) {
            showSpinner.setParams({
                "show": true
            });
            showSpinner.fire();
        }
    }

    // you may only be able to use this if you register the event in the component youre calling it from
    var hideSpinner = function() {
        var showSpinner = $A.get("e.agf:ADM_Event_Show_Spinner");
        if (showSpinner) {
            showSpinner.setParams({
                "show": false
            });
            showSpinner.fire();
        }
    }

    var getColumnFromId = function(id, columns) {

        for (var i = 0, len = columns.length; i < len; i++) {
            var col = columns[i];

            if (col.column.Id === id) {
                return col.column;
            }

            if (col.children) {
                if (getColumnFromId(id, col.children)) {
                    return getColumnFromId(id, col.children);
                };
            }
        }
    }
    var sortStrings = function(a, b) {
        return ('' + a).localeCompare(b)
    }
    var sortNums = function(a, b) {
        return (b != null) - (a != null) || a - b; // sorts in ascending order with nulls last
    }
    var sortBySprintRank = function(a, b) {
        return sortNums(a.m_story.Sprint_Rank__c, b.m_story.Sprint_Rank__c);
    }
    var sortByBoardColumnRank = function(a, b) {
        return sortNums(a.m_story.Board_Column_Rank__c, b.m_story.Board_Column_Rank__c);
    }
    var getAllColumnIds = function(columns) {
        return columns.reduce(function(acc, curr) {
            var id = curr.column.Id;
            if (acc.indexOf(id) == -1) {
                acc = acc.concat(id);
            }
            if (curr.children && curr.children.length) {
                acc = acc.concat(getAllColumnIds(curr.children));
            }
            return acc;
        }, []);
    }
    var getAllColumnsFlattened = function(columns) {
        var colAlreadyAdded = function(cols, id) {
            return cols.filter(function(col) {
                return col.column.Id === id;
            }).length;
        }

        return columns.reduce(function(acc, curr) {
            var id = curr.column.Id;
            if (!colAlreadyAdded(acc, id)) {
                acc = acc.concat(curr);
            }
            if (curr.children && curr.children.length) {
                acc = acc.concat(getAllColumnsFlattened(curr.children));
            }
            return acc;
        }, []);
    }
    var _getWorksFromColumnsOutsideThisBoard = function(sprintData) {
        var allColumnIds = getAllColumnIds(sprintData.boardColumns);

        var boardColumnNotOnThisBoard = function(work) {
            return work.m_story.Board_Column__c && allColumnIds.indexOf(work.m_story.Board_Column__c) === -1;
        };

        return sprintData.sprintWork
            .filter(boardColumnNotOnThisBoard)
    }
    var _makeBoardColumnUndefined = function(work) {
        work.m_story.Board_Column__c = undefined;
        return work;
    }
    var createBoardViewSprintWork = function(sprintData) {
        var helper = this;
        var newSprintWork = [];
        var boardColumnsObj = {
            'undefined': [] // initialize with an undefined value for work that doesnt have a board column.
        };
        var sortedRecordsWithoutBoardColumn = [];
        var sortedRecordsWithBoardColumn = [];
        var getSortedWorkFromColumnReducer = function(acc, id) {
            if (boardColumnsObj[id] && boardColumnsObj[id].length) {
                var sortedWork = boardColumnsObj[id].sort(sortByBoardColumnRank);
                acc = acc.concat(sortedWork);
            }
            return acc;
        }

        // these works don't have a matching column in this board, so make the column undefined
        // so that it gets grouped with other work that has undefined columns.
        _getWorksFromColumnsOutsideThisBoard(sprintData)
            .map(_makeBoardColumnUndefined);

        // create boardColumnsObj - group works by their boardColumn.
        sprintData.sprintWork.forEach(function(work) {
            var boardColumn = work.m_story.Board_Column__c;

            if (boardColumnsObj.hasOwnProperty(boardColumn)) {
                boardColumnsObj[boardColumn].push(work);
            } else {
                boardColumnsObj[boardColumn] = [work];
            }
        });

        // for those without a columnId, sort by sprint rank
        var sortedRecordsWithoutBoardColumn = (boardColumnsObj['undefined']).sort(sortBySprintRank);

        // for those with a columnId,
        // the columns should already be sorted by level and position since boardColumns come back
        // from the server like that.  Within each column, sort the work by Board_Column_Rank__c
        var sortedRecordsWithBoardColumn = getAllColumnIds(sprintData.boardColumns)
            .reduce(getSortedWorkFromColumnReducer, []);

        // those without columnId come first - followed by those with a columnId
        return sortedRecordsWithoutBoardColumn.concat(sortedRecordsWithBoardColumn);
    }

    var createNonBoardViewSprintWork = function(sprintData) {
        return sprintData.sprintWork.sort(sortBySprintRank);
    }

    var hasPermset = function(name, userInfo) {
        var getPermset = function(perm) {
            return perm.PermissionSet.Name === name;
        }

        return userInfo && userInfo.permSets ?
            !!userInfo.permSets.filter(getPermset).length
            : false;
    }

     var serializeSprintDataForNamespace = function(sprintData,currentNode,nameSpace){
        if(nameSpace != null && nameSpace!=''){
            if(typeof sprintData[currentNode] != 'object'){
                sprintData[currentNode.replace(nameSpace, '')] = sprintData[currentNode];
            }
            else{
                sprintData[currentNode.replace(nameSpace, '')] = sprintData[currentNode];
                for(innerNode in sprintData[currentNode]){
                    sprintData[currentNode] = serializeSprintDataForNamespace(sprintData[currentNode],innerNode,nameSpace);
                }
            }
        }

        return sprintData;
    }

    var getMenuAlignment = function(auraElm, containerElm) {
        if (!auraElm || !auraElm.getElement()) {
        	return;
        }
        // this is used to determine the correct menuAlignment for lightning:buttonMenu (like "right")
        // but could also be used to create the class itself, (like "slds-dropdown_bottom").
        // https://developer.salesforce.com/docs/component-library/bundle/lightning:buttonMenu/specification
        // https://www.lightningdesignsystem.com/components/menus/#Positioning

        var elm = auraElm.getElement(); // domElm
        var containerElm = (containerElm && containerElm.getElement()) ? containerElm.getElement() : window; // domElm
        var containerWidth = containerElm.innerWidth;
        var containerHeight = containerElm.innerHeight;
        var elmLeft = elm.getBoundingClientRect().left;
        var elmBottom = elm.getBoundingClientRect().bottom;
        var isAtBottomOfPage = elmBottom / containerHeight > .8;
        var isAtLeftOfPage = elmLeft / containerWidth < .5;
        var isAtRightOfPage = elmLeft / containerWidth > .5;
        var makeDropdownClass = function(position) {
            return 'slds-dropdown_' + position;
        }
        var positions = [];

        if (isAtBottomOfPage) {
            positions.push('bottom'); // important that bottom comes first so we can create bottom-left, bottom-right
        }
        if (isAtLeftOfPage) {
            positions.push('left');
        }
        if (isAtRightOfPage) {
            positions.push('right');
        }

        return positions.join('-') // this allows us to account for bottom-left, bottom-right
    }

    var makeDropdownFixed = function(button, dropdown) {
        // takes in button & dropdown, which should both be DOM elements.
        var maxWidth = 200;
        var maxHeight = 200;
        var dropdownWidth = dropdown.offsetWidth && dropdown.offsetWidth < maxWidth ? dropdown.offsetWidth : maxWidth;
        var dropdownHeight = dropdown.offsetHeight && dropdown.offsetHeight < maxHeight ? dropdown.offsetHeight : maxHeight;
		var buttonBoundingClientRect = button.getBoundingClientRect();
		var buttonLeft = buttonBoundingClientRect.left;
		var buttonRight = buttonBoundingClientRect.right;
		var buttonTop = buttonBoundingClientRect.top;
		var buttonBottom = buttonBoundingClientRect.bottom;
        var buttonHeight = button.offsetHeight;
        var buttonWidth = button.offsetWidth;
		var windowWidth = window.innerWidth;
		var windowHeight = window.innerHeight;
		var heightOfDropdownAndButton = buttonHeight + dropdownHeight;
		var widthOfDropdownAndButton = buttonWidth + dropdownWidth;
		var closeToTop = buttonBottom < heightOfDropdownAndButton;
		var closeToBottom = windowHeight - buttonTop < heightOfDropdownAndButton;
		var closeToLeft = buttonRight < widthOfDropdownAndButton;
		var closeToRight = windowWidth - buttonRight < widthOfDropdownAndButton;

		var numToPx = function(num) { return num.toFixed() + 'px' }

		var dropdownStyleUpdates = {
			position: 'fixed',
			width: numToPx(dropdownWidth),
			height: numToPx(dropdownHeight),
			overflow: 'auto',
            transform: 'none', // slds sometimes applies transforms which would override the left value, so override them.
            webkitTransform: 'none'
		};

		// set top value
		if (closeToBottom) {
			dropdownStyleUpdates.top = numToPx(buttonTop - dropdownHeight);
		} else {
			dropdownStyleUpdates.top = numToPx(buttonBottom);
		}

		// set left value
		if (closeToRight) {
			dropdownStyleUpdates.left = numToPx(buttonRight - dropdownWidth);
		} else {
			dropdownStyleUpdates.left = numToPx(buttonLeft);
		}

		Object.assign(dropdown.style, dropdownStyleUpdates);
    }

    var makeColumnStatusObj = function(status, idx) {
        return {
            label: status.split('---')[0],
            value: status.split('---')[1],
            order: idx
        }
    };

    var makeStatusItems = function(statusAssignmentWrapper) {
        var that = this;
        var getStatusCollectionByType = function(statusAssignmentWrapper, type) {
            return type === 'Bug' ? statusAssignmentWrapper.bugStatuses.map(that.makeColumnStatusObj)
    		: type === 'User Story' ? statusAssignmentWrapper.storyStatuses.map(that.makeColumnStatusObj)
    		: type === 'Investigation' ? statusAssignmentWrapper.investigationStatuses.map(that.makeColumnStatusObj)
    		: [];
    	};
    	var getOrderOfStatusItem = function(statusAssignmentWrapper, statusItem) {
    		return getStatusCollectionByType(statusAssignmentWrapper, statusItem.type)
    			.filter(function(status) {
    				return status.value === statusItem.workStatusId
    			})[0].order;
    	};
		var hasWorkStatusId = function(statusItem) {
			return !!statusItem.workStatusId // we only care items that have id's.
		};
		var createStatusItem = function(statusItem) {
			return {
				columnId: statusItem.columnId,
				type: statusItem.type,
				statusId: statusItem.workStatusId,
				statusName: statusItem.status,
				statusOrder: getOrderOfStatusItem(statusAssignmentWrapper, statusItem)
			}
		};

    	return statusAssignmentWrapper.columnStatusAssignments
			.filter(hasWorkStatusId)
			.map(createStatusItem)

	}

    return {
        isWorkItemVisible: isWorkItemVisible,
        isString: isString,
        isObj: isObj,
        isArr: isArr,
        isBool: isBool,
        valIsInFilterArr: valIsInFilterArr,
        getIdxInFilterArr: getIdxInFilterArr,
        matchesFilterValue: matchesFilterValue,
        getUsersForFiltering: getUsersForFiltering,
        getCurrTeamFilters: getCurrTeamFilters,
        getInitials: getInitials,
        showSpinner: showSpinner,
        hideSpinner: hideSpinner,
        getColumnFromId: getColumnFromId,
        createBoardViewSprintWork: createBoardViewSprintWork,
        createNonBoardViewSprintWork: createNonBoardViewSprintWork,
        hasPermset: hasPermset,
        getMenuAlignment: getMenuAlignment,
        makeDropdownFixed: makeDropdownFixed,
        getAllColumnIds: getAllColumnIds,
        getAllColumnsFlattened: getAllColumnsFlattened,
        sortNums: sortNums,
        sortStrings: sortStrings,
        makeStatusItems: makeStatusItems,
        makeColumnStatusObj: makeColumnStatusObj,
        serializeSprintDataForNamespace:serializeSprintDataForNamespace
    }

}());
