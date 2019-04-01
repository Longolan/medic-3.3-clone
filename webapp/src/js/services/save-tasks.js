var TASK_PARENT_KEYS = ['actions', '_id', 'date', 'contact'];
var TASK_ACTION_KEYS = ['form', 'type', 'content'];
var TASK_ACTION_CONTENT_KEYS = ['source', 'source_id', 'contact'];

(function () {

  'use strict';

  var inboxServices = angular.module('inboxServices');

  inboxServices.factory('SaveTask',
    function ( DB, Session, $q, $log ) {
      'use strict';
      'ngInject';

      function isTaskInvalid(task) {
        console.dir(task);
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

      function saveTask(task) {
        return task.actions.map(function (val) {
          var cache = { type: 'gen-task' };

          cache['form'] = val.form;
          cache['form_type'] = val.type;
          cache['task'] = {
            source: val.content.source,
            source_id: val.content.source_id || 'N/A',
            task_form_label: val.label,
            contact: { name: val.content.contact.name, _id: val.content.contact._id, type: val.content.contact.type },
            priority: task.priority,
            isResolved: task.resolved,
            timestamp: task.date,
          };
          cache['generated_for'] = Session.userCtx().name;
          cache['_id'] = `${task._id}__${new Date(task.date).getTime()}__${val.form}__${cache['task'].source_id}__${Session.userCtx().name}`;

          return cache;
        }).
        reduce(function ($p, task) {

          return $p.then(function () {
            return DB().get(task._id).
              catch(function (err) {
                if (err.name === 'not_found') {
                  return DB().put(task);
                }

                $log.error(JSON.stringify(err));
                return $q.resolve();
              });
          });

        }, $q.resolve());

      }

      return saveTask;
    }
  );

}());
