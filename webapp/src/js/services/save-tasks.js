var TASK_PARENT_KEYS = ['actions', '_id', 'date'];
var TASK_ACTION_KEYS = ['form', 'type', 'content'];
var TASK_ACTION_CONTENT_KEYS = ['source', 'source_id'];

(function () {

  'use strict';

  var inboxServices = angular.module('inboxServices');

  inboxServices.factory('SaveTasks',
    function ( DB, Session, $log ) {
      'use strict';
      'ngInject';

      function isTaskInvalid(task) {
        var isInvalid = false;

        var parentKeys = Object.keys(task);

        for (var pI = 0; pI < parentKeys.length; pI++) {
          if (TASK_PARENT_KEYS.filter(v => v === parentKeys[pI]).length < 1) {
            isInvalid = true;
            break;
          }
        }

        if (task.actions.length < 1) {
          return true;
        }

        task.actions.forEach(action => {
          var actionKeys = Object.keys(action);

          for (var aI = 0; aI < actionKeys.length; aI++) {
            if (TASK_ACTION_KEYS.filter(v => v === actionKeys[aI]).length < 1) {
              isInvalid = true;
              break;
            }
          }

          var actionContentKeys = Object.keys(action.content);

          for (var aCI = 0; aCI < actionContentKeys.length; aCI++) {
            if (TASK_ACTION_CONTENT_KEYS.filter(v => v === actionContentKeys[aCI]).length < 1) {
              isInvalid = true;
              break;
            }
          }
        });

        return isInvalid;
      }

      var saveTask = function (task) {
        if (isTaskInvalid(task)) {
          return;
        }
      }

      var queryTask = function (searchTerm) { }

      return {
        save: saveTask,
        query: queryTask,
      };
    }
  );

}());
