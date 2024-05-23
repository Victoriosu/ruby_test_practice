import "jquery"; // this import first

$('.test-option#silver, .test-option#gold').on('click',function(){
    $.ajax({ type: "GET", url:"fetch_test_status?test_type="+$(this).attr('id')});
})