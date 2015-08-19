ARBOR.hypotheses.init = function() {
  var $hypothesesList = $('.hypotheses-list');

  function refreshOrder(hypotheses) {
    var orderedHypotheses = [];
    $.each(hypotheses, function(index, hypothesis) {
      var id = hypothesis.dataset.id,
          order = index + 1,
          hypothesisToOrder = {
            id: parseInt(id),
            order: order
          };

      if(hypotheses.length > order) orderedHypotheses.push(hypothesisToOrder);
    });
    return orderedHypotheses;
  }

  function setOrder(newOrder) {
    var $order = $('.order');
    $.each($order, function(index, bullet) {
      if($order.length > index + 1) {
        bullet.innerHTML = newOrder[index].order;
      }
    });
  }

  $hypothesesList.sortable({
    stop: function() {
      var $hypothesis = $('.hypothesis'),
          newOrder = refreshOrder($hypothesis),
          projectPath = $(this).data('projectPath');

      $.ajax({
        url: projectPath,
        dataType: 'json',
        method: 'PUT',
        data: { new_order: newOrder }
      }).done(function() {
        setOrder(newOrder);
      });
    }
  });
};
