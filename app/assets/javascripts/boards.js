// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
function divCoordsToInt(coordsStr) {
  var coordsIntAry = [];
  var coordsStrAry = coordsStr.split("-");
  for (var i in coordsStrAry) {
    coordsIntAry[i] = parseInt(coordsStrAry[i]);
  }
  return coordsIntAry;
}

$(document).ready(function(){
  $('div.row').on('click', '.square', function(){
    var board_id = $('div.board').attr('id');
    var coordsIntAry = divCoordsToInt($(this).attr('id'));
    $.ajax({
      type: "POST",
      url: "index",
      data: {
        board_id: board_id,
        coordsIntAry: coordsIntAry
      }
    });
  });
});
