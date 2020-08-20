$(document).ready(function() {
    // Listen for NUI Events
    window.addEventListener('message', function(event) {
        var item = event.data;
        // Trigger adding a new message to the log and create its display
        if (item.open === 2) {
            // console.log(3)
            // update(item.info);

            if (item.direction) {
                $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
                return;
            }

            if (item.atl === false) {
                $(".atlamount").attr("style", "display: none");
                $(".atlamounttxt").attr("style", "display: none");
            } else {
                $(".atlamount").attr("style", "display: block");
                $(".atlamounttxt").attr("style", "display: block");
                $(".atlamount").empty();
                $(".atlamount").append(item.atl);
            }
            if (item.blacklist === true) {
                $(".fuelamount").attr("style", "display: none");
                $(".smalltext2").attr("style", "display: none");
                $(".belt").attr("style", "display: none");
                $(".FUEL").attr("style", "display: none");
                $(".totalkm").attr("style", "display: none");
                $(".ENGINE").attr("style", "display: none");
            } else {
                $(".fuelamount").attr("style", "display: block");
                $(".smalltext2").attr("style", "display: block");
                
            }


            $(".fuelamount").empty();
            $(".fuelamount").append(item.fuel);

            if (item.GasTank === true) {
                $(".FUEL").fadeIn(1000);
            } else {
                $(".FUEL").fadeOut(1000);
            }

            if (item.belt == true) {
                $(".belt").fadeOut(1000);
            } else {
                $(".belt").fadeIn(1000);
            }

            
        if (item.engine === true) {
            $(".ENGINE").fadeIn(1000);
        } else {
            $(".ENGINE").fadeOut(1000);
        }

            $(".vehicle").removeClass("hide");
            $(".wrap").removeClass("lower");
            $(".time").removeClass("timelower");

           

            $(".speedamount").empty();
            $(".speedamount").append(item.mph);

            $(".totalkm").empty();
            $(".totalkm").append(item.km);

            $(".street-txt").empty();
            $(".street-txt").append(item.street);

            $(".time").empty();
            $(".time").append(item.time);


         


            $(".nos").empty();
            if (item.nos > 0) {
                if (item.nosEnabled === false) {
                    let colorOn = (item.colorblind) ? 'blue' : 'green';
                    $(".nos").append(`<div class='${colorOn}'> ${item.nos} </div>`);
                } else {
                    let colorOff = (item.colorblind) ? 'yellow' : 'yellow';
                    $(".nos").append(`<div class='${colorOff}'> ${item.nos} </div>`);
                }
            }
        }

        if (item.open === 4) {
            $(".vehicle").addClass("hide");
            $(".wrap").addClass("lower");
            $(".time").addClass("timelower");
            $(".fuelamount").empty();
            $(".speedamount").empty();
            $(".street-txt").empty();

            $(".time").empty();
            $(".time").append(item.time);
            $(".direction").find(".image").attr('style', 'transform: translate3d(' + item.direction + 'px, 0px, 0px)');
        }

        if (item.open === 3) {
            $(".full-screen").fadeOut(100);
        }
        if (item.open === 1) {
            //console.log(1)
            $(".full-screen").fadeIn(100);
        }
    });
});