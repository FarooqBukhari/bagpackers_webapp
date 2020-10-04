// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require theme_files/jquery-3.2.1.min.js
//= require jquery_ujs
//= require cable
//= require filterrific/filterrific-jquery
//= require_self


$(document).ready(function() {

// In your Javascript (external .js resource or <script> tag)
    $('.js-example-basic-single').select2();
    $('.js-example-basic-multiple').select2();
    (function() {
        $(document).on('click', '.toggle-window', function(e) {
            e.preventDefault();
            var panel = $(this).parent().parent();
            var messages_list = panel.find('.messages-list');

            panel.find('.panel-body').toggle();
            // panel.attr('class', 'panel panel-default');
            //
            // if (panel.find('.panel-body').is(':visible')) {
            //     var height = messages_list[0].scrollHeight;
            //     messages_list.scrollTop(height);
            // }
        });
    })();


    /* 1. Visualizing things on Hover - See next part for action on click */
    $('#stars li').on('mouseover', function(){
        var onStar = parseInt($(this).data('value'), 10); // The star currently mouse on

        // Now highlight all the stars that's not after the current hovered star
        $(this).parent().children('li.star').each(function(e){
            if (e < onStar) {
                $(this).addClass('hover');
            }
            else {
                $(this).removeClass('hover');
            }
        });

    }).on('mouseout', function(){
        $(this).parent().children('li.star').each(function(e){
            $(this).removeClass('hover');
        });
    });


    /* 2. Action to perform on click */
    $('#stars li').on('click', function(){
        var onStar = parseInt($(this).data('value'), 10); // The star currently selected
        var stars = $(this).parent().children('li.star');

        for (i = 0; i < stars.length; i++) {
            $(stars[i]).removeClass('selected');
        }

        for (i = 0; i < onStar; i++) {
            $(stars[i]).addClass('selected');
        }
        if(window.location.pathname.includes("tours")){
            $('#tour_review_rating')[0].value = onStar;
        }
        if(window.location.pathname.includes("hotels")){
            $('#hotel_review_rating')[0].value = onStar;
        }

    });


    if (window.location.href.indexOf("feed") > -1) {
        next_button = $('.pagination > .next_page');
        next_button.addClass("btn");
        $('.pagination').empty();
        $('.pagination').append(next_button);

        $('#endless-scroll').removeClass('hidden');
        $('#endless-scroll').removeClass('well');
    }

    /* accordion.js */

    function getAccordion(element_id,screen)
    {
        $(window).resize(function () { location.reload(); });

        if ($(window).width() < screen)
        {
            var concat = '';
            obj_tabs = $( element_id + " li" ).toArray();
            obj_cont = $( ".tab-content .tab-pane" ).toArray();
            jQuery.each( obj_tabs, function( n, val )
            {
                concat += '<div id="' + n + '" class="panel panel-default">';
                concat += '<div class="panel-heading" role="tab" id="heading' + n + '">';
                concat += '<h4 class="panel-title"><a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapse' + n + '" aria-expanded="false" aria-controls="collapse' + n + '">' + val.innerText + '</a></h4>';
                concat += '</div>';
                concat += '<div id="collapse' + n + '" class="panel-collapse collapse" role="tabpanel" aria-labelledby="heading' + n + '">';
                concat += '<div class="panel-body">' + obj_cont[n].innerHTML + '</div>';
                concat += '</div>';
                concat += '</div>';
            });
            $("#accordion").html(concat);
            $("#accordion").find('.panel-collapse:first').addClass("in");
            $("#accordion").find('.panel-title a:first').attr("aria-expanded","true");
            $(element_id).remove();
            $(".tab-content").remove();
        }
    }

    // STICKIT
    /**
     * [jQuery-stickit]{@link https://github.com/emn178/jquery-stickit}
     *
     * @version 0.2.11
     * @author Chen, Yi-Cyuan [emn178@gmail.com]
     * @copyright Chen, Yi-Cyuan 2014-2016
     * @license MIT
     */
    (function ($) {
        var KEY = 'jquery-stickit';
        var SPACER_KEY = KEY + '-spacer';
        var SELECTOR = ':' + KEY;
        var IE7 = navigator.userAgent.indexOf('MSIE 7.0') != -1;
        var OFFSET = IE7 ? -2 : 0;
        var LOCATIING_KEY = KEY + '-locating';
        var MUTATION = window.MutationObserver !== undefined;
        var animationend = 'animationend webkitAnimationEnd oAnimationEnd';
        var transitionend = 'transitionend webkitTransitionEnd oTransitionEnd';
        var fullscreenchange = 'webkitfullscreenchange mozfullscreenchange fullscreenchange MSFullscreenChange';

        var Scope = window.StickScope = {
            Parent: 0,
            Document: 1
        };

        var Stick = {
            None: 0,
            Fixed: 1,
            Absolute: 2
        };

        var init = false;

        function throttle(func) {
            var delay = 10;
            var lastTime = 0;
            var timer;
            return function () {
                var self = this, args = arguments;
                var exec = function () {
                    lastTime = new Date();
                    func.apply(self, args);
                };
                if (timer) {
                    clearTimeout(timer);
                    timer = null;
                }
                var diff = new Date() - lastTime;
                if (diff > delay) {
                    exec();
                } else {
                    timer = setTimeout(exec, delay - diff);
                }
            };
        }

        $.expr[':'][KEY] = function (element) {
            return !!$(element).data(KEY);
        };

        function Sticker(element, optionList) {
            this.element = $(element);
            this.lastValues = {};
            if (!$.isArray(optionList)) {
                optionList = [optionList || {}];
            }
            if (!optionList.length) {
                optionList.push({});
            }
            this.optionList = optionList;
            var transform = this.element.css('transform') || '';
            this.defaultZIndex = this.element.css('z-index') || 100;
            if (this.defaultZIndex == 'auto') {
                this.defaultZIndex = 100;
            } else if (this.defaultZIndex == '0' && transform != 'none') {
                this.defaultZIndex = 100;
            }
            this.updateOptions();

            this.offsetY = 0;
            this.lastY = 0;
            this.stick = Stick.None;
            this.spacer = $('<div />');
            this.spacer[0].id = element.id;
            this.spacer[0].className = element.className;
            this.spacer[0].style.cssText = element.style.cssText;
            this.spacer.addClass(SPACER_KEY);
            this.spacer[0].style.cssText += ';visibility: hidden !important;display: none !important';
            this.spacer.insertAfter(this.element);
            if (this.element.parent().css('position') == 'static') {
                this.element.parent().css('position', 'relative');
            }
            this.origWillChange = this.element.css('will-change');
            if (this.origWillChange == 'auto') {
                this.element.css('will-change', 'transform');
            }
            if (transform == 'none') {
                this.element.css('transform', 'translateZ(0)');
            } else if (transform.indexOf('matrix3d') == -1) {
                this.element.css('transform', this.element.css('transform') + ' translateZ(0)');
            }
            this.bound();
            this.precalculate();
            this.store();
        }

        Sticker.prototype.trigger = function (eventName) {
            var name = 'on' + eventName.charAt(0).toUpperCase() + eventName.slice(1);
            if (this.options[name]) {
                this.options[name].call(this.element);
            }
            this.element.trigger('stickit:' + eventName);
        };

        Sticker.prototype.isActive = function (options) {
            return (options.screenMinWidth === undefined || screenWidth >= options.screenMinWidth) &&
                (options.screenMaxWidth === undefined || screenWidth <= options.screenMaxWidth);
        };

        Sticker.prototype.updateCss = function (options) {
            if (this.element.hasClass(this.options.className) && options.className != this.options.className) {
                this.element.removeClass(this.options.className).addClass(options.className);
            }
            var update = {};
            if (this.stick == Stick.Absolute) {
                if (this.options.extraHeight != options.extraHeight) {
                    update.bottom = -this.options.extraHeight + 'px';
                }
            } else {
                if (this.options.top != options.top) {
                    update.top = (options.top + this.offsetY) + 'px';
                }
            }
            if (this.options.zIndex != options.zIndex) {
                update.zIndex = this.getZIndex(options);
            }
            this.element.css(update);
        };

        Sticker.prototype.updateOptions = function () {
            var activeKey = this.getActiveOptionsKey();
            if (this.activeKey == activeKey) {
                return;
            }
            this.activeKey = activeKey;
            var options = this.getActiveOptions();
            if (this.options) {
                if (!activeKey) {
                    this.reset();
                } else if (this.stick != Stick.None) {
                    if (options.scope == this.options.scope) {
                        this.updateCss(options);
                    } else {
                        this.reset();
                        setTimeout(this.locate.bind(this));
                    }
                }
            }
            this.options = options;
            this.zIndex = this.getZIndex(options);
        };

        Sticker.prototype.getZIndex = function (options) {
            return options.zIndex === undefined ? this.defaultZIndex : options.zIndex;
        };

        Sticker.prototype.getActiveOptionsKey = function () {
            var indices = [];
            for (var i = 0;i < this.optionList.length;++i) {
                if (this.isActive(this.optionList[i])) {
                    indices.push(i);
                }
            }
            return indices.join('_');
        };

        Sticker.prototype.getActiveOptions = function () {
            var options = {};
            for (var i = 0;i < this.optionList.length;++i) {
                var opt = this.optionList[i];
                if (this.isActive(opt)) {
                    $.extend(options, opt);
                }
            }
            options.scope = options.scope || Scope.Parent;
            options.className = options.className || 'stick';
            options.top = options.top || 0;
            options.extraHeight = options.extraHeight || 0;
            if (options.overflowScrolling === undefined) {
                options.overflowScrolling = true;
            }
            return options;
        };

        Sticker.prototype.store = function () {
            var element = this.element[0];
            this.origStyle = {
                width: element.style.width,
                position: element.style.position,
                left: element.style.left,
                top: element.style.top,
                bottom: element.style.bottom,
                zIndex: element.style.zIndex
            };
        };

        Sticker.prototype.restore = function () {
            this.element.css(this.origStyle);
        };

        Sticker.prototype.bound = function () {
            var element = this.element;
            if (!IE7 && element.css('box-sizing') == 'border-box') {
                var bl = parseFloat(element.css('border-left-width')) || 0;
                var br = parseFloat(element.css('border-right-width')) || 0;
                var pl = parseFloat(element.css('padding-left')) || 0;
                var pr = parseFloat(element.css('padding-right')) || 0;
                this.extraWidth = bl + br + pl + pr;
            } else {
                this.extraWidth = 0;
            }

            this.margin = {
                top: parseFloat(element.css('margin-top')) || 0,
                bottom: parseFloat(element.css('margin-bottom')) || 0,
                left: parseFloat(element.css('margin-left')) || 0,
                right: parseFloat(element.css('margin-right')) || 0
            };
            this.parent = {
                border: {
                    bottom: parseFloat(element.parent().css('border-bottom-width')) || 0
                }
            };
        };

        Sticker.prototype.precalculate = function () {
            this.baseTop = this.margin.top + this.options.top;
            this.basePadding = this.baseTop + this.margin.bottom;
            this.baseParentOffset = this.options.extraHeight - this.parent.border.bottom;
            this.offsetHeight = this.options.overflowScrolling ? Math.max(this.element.outerHeight(false) + this.basePadding - screenHeight, 0) : 0;
            this.minOffsetHeight = -this.offsetHeight;
        };

        Sticker.prototype.reset = function () {
            if (this.stick == Stick.Absolute) {
                this.trigger('unend');
                this.trigger('unstick');
            } else if (this.stick == Stick.Fixed) {
                this.trigger('unstick');
            }
            this.stick = Stick.None;
            this.spacer.css('width', this.origStyle.width);
            this.spacer[0].style.cssText += ';display: none !important';
            this.restore();
            this.element.removeClass(this.options.className);
        };

        Sticker.prototype.setAbsolute = function (left) {
            if (this.stick == Stick.None) {
                this.element.addClass(this.options.className);
                this.trigger('stick');
                this.trigger('end');
            } else {
                this.trigger('end');
            }
            this.stick = Stick.Absolute;
            this.element.css({
                width: this.element.width() + this.extraWidth + 'px',
                position: 'absolute',
                top: this.origStyle.top,
                left: left + 'px',
                bottom: -this.options.extraHeight + 'px',
                'z-index': this.zIndex
            });
        };

        Sticker.prototype.setFixed = function (left, lastY, offsetY) {
            if (this.stick == Stick.None) {
                this.element.addClass(this.options.className);
                this.trigger('stick');
            } else {
                this.trigger('unend');
            }
            if (!this.options.overflowScrolling) {
                offsetY = 0;
            }
            this.stick = Stick.Fixed;
            this.lastY = lastY;
            this.offsetY = offsetY;
            this.element.css({
                width: this.element.width() + this.extraWidth  + 'px',
                position: 'fixed',
                top: (this.options.top + offsetY) + 'px',
                left: left + 'px',
                bottom: this.origStyle.bottom,
                'z-index': this.zIndex
            });
        };

        Sticker.prototype.updateScroll = function (newY) {
            if (this.offsetHeight == 0 || !this.options.overflowScrolling) {
                return;
            }
            var offsetY = Math.max(this.offsetY + newY - this.lastY, this.minOffsetHeight);
            offsetY = Math.min(offsetY, 0);
            this.lastY = newY;
            if (this.offsetY == offsetY) {
                return;
            }
            this.offsetY = offsetY;
            this.element.css('top', (this.options.top + this.offsetY) + 'px');
        };

        Sticker.prototype.isHigher = function () {
            return this.options.scope == Scope.Parent && this.element.parent().height() <= this.element.outerHeight(false) + this.basePadding;
        };

        Sticker.prototype.locate = function () {
            if (!this.activeKey) {
                return;
            }
            var rect, top, left, element = this.element, spacer = this.spacer;
            element.data(LOCATIING_KEY, true);
            switch (this.stick) {
                case Stick.Fixed:
                    rect = spacer[0].getBoundingClientRect();
                    top = rect.top - this.baseTop;
                    if (top >= 0 || this.isHigher()) {
                        this.reset();
                    } else if (this.options.scope == Scope.Parent) {
                        rect = element.parent()[0].getBoundingClientRect();
                        if (rect.bottom + this.baseParentOffset + this.offsetHeight <= element.outerHeight(false) + this.basePadding) {
                            this.setAbsolute(this.spacer.position().left);
                        } else {
                            this.updateScroll(rect.bottom);
                        }
                    } else {
                        this.updateScroll(rect.bottom);
                    }
                    break;
                case Stick.Absolute:
                    rect = spacer[0].getBoundingClientRect();
                    top = rect.top - this.baseTop;
                    left = rect.left - this.margin.left;
                    if (top >= 0 || this.isHigher()) {
                        this.reset();
                    } else {
                        rect = element.parent()[0].getBoundingClientRect();
                        if (rect.bottom + this.baseParentOffset + this.offsetHeight > element.outerHeight(false) + this.basePadding) {
                            this.setFixed(left + OFFSET, rect.bottom, -this.offsetHeight);
                        }
                    }
                    break;
                case Stick.None:
                /* falls through */
                default:
                    rect = element[0].getBoundingClientRect();
                    top = rect.top - this.baseTop;
                    if (top >= 0 || this.isHigher()) {
                        return;
                    }

                    var rect2 = element.parent()[0].getBoundingClientRect();
                    spacer.height(element.height());
                    spacer.show();
                    left = rect.left - this.margin.left;
                    if (this.options.scope == Scope.Document) {
                        this.setFixed(left, rect.bottom, 0);
                    } else {
                        if (rect2.bottom + this.baseParentOffset + this.offsetHeight <= element.outerHeight(false) + this.basePadding) {
                            this.setAbsolute(this.element.position().left);
                        } else {
                            this.setFixed(left + OFFSET, rect.bottom, 0);
                        }
                    }

                    if (!spacer.width()) {
                        spacer.width(element.width());
                    }
                    break;
            }
        };

        Sticker.prototype.refresh = function () {
            this.updateOptions();
            this.bound();
            this.precalculate();
            if (this.stick == Stick.None) {
                this.locate();
                return;
            }
            var element = this.element;
            var spacer = this.spacer;
            if (this.lastValues.width != spacer.width()) {
                element.width(this.lastValues.width = spacer.width());
            }
            if (this.lastValues.height != spacer.height()) {
                spacer.height(this.lastValues.height = spacer.height());
            }
            if (this.stick == Stick.Fixed) {
                var rect = this.spacer[0].getBoundingClientRect();
                var left = rect.left - this.margin.left;
                if (this.lastValues.left != left + 'px') {
                    element.css('left', this.lastValues.left = left + 'px');
                }
            }
            this.locate();
        };

        Sticker.prototype.destroy = function () {
            this.reset();
            this.spacer.remove();
            this.element.removeData(KEY);
        };

        Sticker.prototype.enableWillChange = function (enabled) {
            if (this.origWillChange != 'auto') {
                return;
            }
            this.element.css('will-change', enabled ? 'transform' : this.origWillChange);
        };

        var screenHeight, screenWidth;
        function resize() {
            screenHeight = window.innerHeight || document.documentElement.clientHeight;
            screenWidth = window.innerWidth || document.documentElement.clientWidth;
            refresh();
        }

        function refresh() {
            $(SELECTOR).each(function () {
                $(this).data(KEY).refresh();
            });
        }

        function scroll() {
            $(SELECTOR).each(function () {
                $(this).data(KEY).locate();
            });
        };

        function onFullscreenChange() {
            var fullscreen = !!(document.fullscreenElement || document.mozFullScreenElement || document.webkitFullscreenElement || document.msFullscreenElement);
            $(SELECTOR).each(function () {
                $(this).data(KEY).enableWillChange(!fullscreen);
            });
        }

        var throttleRefresh = throttle(refresh);

        function mutationUpdate(records) {
            var notAllLocating = records.some(function (record) {
                var element = $(record.target);
                var locating = element.data(LOCATIING_KEY);
                if (locating) {
                    element.removeData(LOCATIING_KEY);
                }
                return !element.hasClass(SPACER_KEY) && !locating;
            });
            if (notAllLocating) {
                throttleRefresh();
            }
        }

        var PublicMethods = ['destroy', 'refresh'];
        $.fn.stickit = function (method, options) {
            // init
            if (typeof(method) == 'string') {
                if ($.inArray(method, PublicMethods) != -1) {
                    var args = arguments;
                    this.each(function () {
                        var sticker = $(this).data(KEY);
                        if (sticker) {
                            sticker[method].apply(sticker, Array.prototype.slice.call(args, 1));
                        }
                    });
                }
            } else {
                if (!init) {
                    init = true;
                    resize();
                    $(document).ready(function () {
                        $(window).bind('resize', resize).bind('scroll', scroll);
                        $(document.body).bind(animationend + ' ' + transitionend, scroll);
                        $(document).bind(fullscreenchange, onFullscreenChange);
                    });

                    if (MUTATION) {
                        var observer = new MutationObserver(mutationUpdate);
                        observer.observe(document, {
                            attributes: true,
                            childList: true,
                            characterData: true,
                            subtree: true
                        });
                    }
                }

                if ($.isArray(method)) {
                    options = method;
                } else {
                    options = Array.prototype.slice.call(arguments, 0);
                }
                this.each(function () {
                    var sticker = new Sticker(this, options);
                    $(this).data(KEY, sticker);
                    sticker.locate();
                });
            }
            return this;
        };

        $.stickit = {
            refresh: refresh
        };
    })(jQuery);


    // date picker
    !function(a){"function"==typeof define&&define.amd?define(["jquery"],a):a("object"==typeof exports?require("jquery"):jQuery)}(function(a,b){function c(){return new Date(Date.UTC.apply(Date,arguments))}function d(){var a=new Date;return c(a.getFullYear(),a.getMonth(),a.getDate())}function e(a,b){return a.getUTCFullYear()===b.getUTCFullYear()&&a.getUTCMonth()===b.getUTCMonth()&&a.getUTCDate()===b.getUTCDate()}function f(c,d){return function(){return d!==b&&a.fn.datepicker.deprecated(d),this[c].apply(this,arguments)}}function g(a){return a&&!isNaN(a.getTime())}function h(b,c){function d(a,b){return b.toLowerCase()}var e,f=a(b).data(),g={},h=new RegExp("^"+c.toLowerCase()+"([A-Z])");c=new RegExp("^"+c.toLowerCase());for(var i in f)c.test(i)&&(e=i.replace(h,d),g[e]=f[i]);return g}function i(b){var c={};if(q[b]||(b=b.split("-")[0],q[b])){var d=q[b];return a.each(p,function(a,b){b in d&&(c[b]=d[b])}),c}}var j=function(){var b={get:function(a){return this.slice(a)[0]},contains:function(a){for(var b=a&&a.valueOf(),c=0,d=this.length;c<d;c++)if(0<=this[c].valueOf()-b&&this[c].valueOf()-b<864e5)return c;return-1},remove:function(a){this.splice(a,1)},replace:function(b){b&&(a.isArray(b)||(b=[b]),this.clear(),this.push.apply(this,b))},clear:function(){this.length=0},copy:function(){var a=new j;return a.replace(this),a}};return function(){var c=[];return c.push.apply(c,arguments),a.extend(c,b),c}}(),k=function(b,c){a.data(b,"datepicker",this),this._process_options(c),this.dates=new j,this.viewDate=this.o.defaultViewDate,this.focusDate=null,this.element=a(b),this.isInput=this.element.is("input"),this.inputField=this.isInput?this.element:this.element.find("input"),this.component=!!this.element.hasClass("date")&&this.element.find(".add-on, .input-group-addon, .btn"),this.component&&0===this.component.length&&(this.component=!1),this.isInline=!this.component&&this.element.is("div"),this.picker=a(r.template),this._check_template(this.o.templates.leftArrow)&&this.picker.find(".prev").html(this.o.templates.leftArrow),this._check_template(this.o.templates.rightArrow)&&this.picker.find(".next").html(this.o.templates.rightArrow),this._buildEvents(),this._attachEvents(),this.isInline?this.picker.addClass("datepicker-inline").appendTo(this.element):this.picker.addClass("datepicker-dropdown dropdown-menu"),this.o.rtl&&this.picker.addClass("datepicker-rtl"),this.o.calendarWeeks&&this.picker.find(".datepicker-days .datepicker-switch, thead .datepicker-title, tfoot .today, tfoot .clear").attr("colspan",function(a,b){return Number(b)+1}),this._process_options({startDate:this._o.startDate,endDate:this._o.endDate,daysOfWeekDisabled:this.o.daysOfWeekDisabled,daysOfWeekHighlighted:this.o.daysOfWeekHighlighted,datesDisabled:this.o.datesDisabled}),this._allow_update=!1,this.setViewMode(this.o.startView),this._allow_update=!0,this.fillDow(),this.fillMonths(),this.update(),this.isInline&&this.show()};k.prototype={constructor:k,_resolveViewName:function(b){return a.each(r.viewModes,function(c,d){if(b===c||a.inArray(b,d.names)!==-1)return b=c,!1}),b},_resolveDaysOfWeek:function(b){return a.isArray(b)||(b=b.split(/[,\s]*/)),a.map(b,Number)},_check_template:function(c){try{if(c===b||""===c)return!1;if((c.match(/[<>]/g)||[]).length<=0)return!0;var d=a(c);return d.length>0}catch(a){return!1}},_process_options:function(b){this._o=a.extend({},this._o,b);var e=this.o=a.extend({},this._o),f=e.language;q[f]||(f=f.split("-")[0],q[f]||(f=o.language)),e.language=f,e.startView=this._resolveViewName(e.startView),e.minViewMode=this._resolveViewName(e.minViewMode),e.maxViewMode=this._resolveViewName(e.maxViewMode),e.startView=Math.max(this.o.minViewMode,Math.min(this.o.maxViewMode,e.startView)),e.multidate!==!0&&(e.multidate=Number(e.multidate)||!1,e.multidate!==!1&&(e.multidate=Math.max(0,e.multidate))),e.multidateSeparator=String(e.multidateSeparator),e.weekStart%=7,e.weekEnd=(e.weekStart+6)%7;var g=r.parseFormat(e.format);e.startDate!==-(1/0)&&(e.startDate?e.startDate instanceof Date?e.startDate=this._local_to_utc(this._zero_time(e.startDate)):e.startDate=r.parseDate(e.startDate,g,e.language,e.assumeNearbyYear):e.startDate=-(1/0)),e.endDate!==1/0&&(e.endDate?e.endDate instanceof Date?e.endDate=this._local_to_utc(this._zero_time(e.endDate)):e.endDate=r.parseDate(e.endDate,g,e.language,e.assumeNearbyYear):e.endDate=1/0),e.daysOfWeekDisabled=this._resolveDaysOfWeek(e.daysOfWeekDisabled||[]),e.daysOfWeekHighlighted=this._resolveDaysOfWeek(e.daysOfWeekHighlighted||[]),e.datesDisabled=e.datesDisabled||[],a.isArray(e.datesDisabled)||(e.datesDisabled=e.datesDisabled.split(",")),e.datesDisabled=a.map(e.datesDisabled,function(a){return r.parseDate(a,g,e.language,e.assumeNearbyYear)});var h=String(e.orientation).toLowerCase().split(/\s+/g),i=e.orientation.toLowerCase();if(h=a.grep(h,function(a){return/^auto|left|right|top|bottom$/.test(a)}),e.orientation={x:"auto",y:"auto"},i&&"auto"!==i)if(1===h.length)switch(h[0]){case"top":case"bottom":e.orientation.y=h[0];break;case"left":case"right":e.orientation.x=h[0]}else i=a.grep(h,function(a){return/^left|right$/.test(a)}),e.orientation.x=i[0]||"auto",i=a.grep(h,function(a){return/^top|bottom$/.test(a)}),e.orientation.y=i[0]||"auto";else;if(e.defaultViewDate instanceof Date||"string"==typeof e.defaultViewDate)e.defaultViewDate=r.parseDate(e.defaultViewDate,g,e.language,e.assumeNearbyYear);else if(e.defaultViewDate){var j=e.defaultViewDate.year||(new Date).getFullYear(),k=e.defaultViewDate.month||0,l=e.defaultViewDate.day||1;e.defaultViewDate=c(j,k,l)}else e.defaultViewDate=d()},_events:[],_secondaryEvents:[],_applyEvents:function(a){for(var c,d,e,f=0;f<a.length;f++)c=a[f][0],2===a[f].length?(d=b,e=a[f][1]):3===a[f].length&&(d=a[f][1],e=a[f][2]),c.on(e,d)},_unapplyEvents:function(a){for(var c,d,e,f=0;f<a.length;f++)c=a[f][0],2===a[f].length?(e=b,d=a[f][1]):3===a[f].length&&(e=a[f][1],d=a[f][2]),c.off(d,e)},_buildEvents:function(){var b={keyup:a.proxy(function(b){a.inArray(b.keyCode,[27,37,39,38,40,32,13,9])===-1&&this.update()},this),keydown:a.proxy(this.keydown,this),paste:a.proxy(this.paste,this)};this.o.showOnFocus===!0&&(b.focus=a.proxy(this.show,this)),this.isInput?this._events=[[this.element,b]]:this.component&&this.inputField.length?this._events=[[this.inputField,b],[this.component,{click:a.proxy(this.show,this)}]]:this._events=[[this.element,{click:a.proxy(this.show,this),keydown:a.proxy(this.keydown,this)}]],this._events.push([this.element,"*",{blur:a.proxy(function(a){this._focused_from=a.target},this)}],[this.element,{blur:a.proxy(function(a){this._focused_from=a.target},this)}]),this.o.immediateUpdates&&this._events.push([this.element,{"changeYear changeMonth":a.proxy(function(a){this.update(a.date)},this)}]),this._secondaryEvents=[[this.picker,{click:a.proxy(this.click,this)}],[this.picker,".prev, .next",{click:a.proxy(this.navArrowsClick,this)}],[this.picker,".day:not(.disabled)",{click:a.proxy(this.dayCellClick,this)}],[a(window),{resize:a.proxy(this.place,this)}],[a(document),{"mousedown touchstart":a.proxy(function(a){this.element.is(a.target)||this.element.find(a.target).length||this.picker.is(a.target)||this.picker.find(a.target).length||this.isInline||this.hide()},this)}]]},_attachEvents:function(){this._detachEvents(),this._applyEvents(this._events)},_detachEvents:function(){this._unapplyEvents(this._events)},_attachSecondaryEvents:function(){this._detachSecondaryEvents(),this._applyEvents(this._secondaryEvents)},_detachSecondaryEvents:function(){this._unapplyEvents(this._secondaryEvents)},_trigger:function(b,c){var d=c||this.dates.get(-1),e=this._utc_to_local(d);this.element.trigger({type:b,date:e,viewMode:this.viewMode,dates:a.map(this.dates,this._utc_to_local),format:a.proxy(function(a,b){0===arguments.length?(a=this.dates.length-1,b=this.o.format):"string"==typeof a&&(b=a,a=this.dates.length-1),b=b||this.o.format;var c=this.dates.get(a);return r.formatDate(c,b,this.o.language)},this)})},show:function(){if(!(this.inputField.prop("disabled")||this.inputField.prop("readonly")&&this.o.enableOnReadonly===!1))return this.isInline||this.picker.appendTo(this.o.container),this.place(),this.picker.show(),this._attachSecondaryEvents(),this._trigger("show"),(window.navigator.msMaxTouchPoints||"ontouchstart"in document)&&this.o.disableTouchKeyboard&&a(this.element).blur(),this},hide:function(){return this.isInline||!this.picker.is(":visible")?this:(this.focusDate=null,this.picker.hide().detach(),this._detachSecondaryEvents(),this.setViewMode(this.o.startView),this.o.forceParse&&this.inputField.val()&&this.setValue(),this._trigger("hide"),this)},destroy:function(){return this.hide(),this._detachEvents(),this._detachSecondaryEvents(),this.picker.remove(),delete this.element.data().datepicker,this.isInput||delete this.element.data().date,this},paste:function(b){var c;if(b.originalEvent.clipboardData&&b.originalEvent.clipboardData.types&&a.inArray("text/plain",b.originalEvent.clipboardData.types)!==-1)c=b.originalEvent.clipboardData.getData("text/plain");else{if(!window.clipboardData)return;c=window.clipboardData.getData("Text")}this.setDate(c),this.update(),b.preventDefault()},_utc_to_local:function(a){if(!a)return a;var b=new Date(a.getTime()+6e4*a.getTimezoneOffset());return b.getTimezoneOffset()!==a.getTimezoneOffset()&&(b=new Date(a.getTime()+6e4*b.getTimezoneOffset())),b},_local_to_utc:function(a){return a&&new Date(a.getTime()-6e4*a.getTimezoneOffset())},_zero_time:function(a){return a&&new Date(a.getFullYear(),a.getMonth(),a.getDate())},_zero_utc_time:function(a){return a&&c(a.getUTCFullYear(),a.getUTCMonth(),a.getUTCDate())},getDates:function(){return a.map(this.dates,this._utc_to_local)},getUTCDates:function(){return a.map(this.dates,function(a){return new Date(a)})},getDate:function(){return this._utc_to_local(this.getUTCDate())},getUTCDate:function(){var a=this.dates.get(-1);return a!==b?new Date(a):null},clearDates:function(){this.inputField.val(""),this.update(),this._trigger("changeDate"),this.o.autoclose&&this.hide()},setDates:function(){var b=a.isArray(arguments[0])?arguments[0]:arguments;return this.update.apply(this,b),this._trigger("changeDate"),this.setValue(),this},setUTCDates:function(){var b=a.isArray(arguments[0])?arguments[0]:arguments;return this.setDates.apply(this,a.map(b,this._utc_to_local)),this},setDate:f("setDates"),setUTCDate:f("setUTCDates"),remove:f("destroy","Method `remove` is deprecated and will be removed in version 2.0. Use `destroy` instead"),setValue:function(){var a=this.getFormattedDate();return this.inputField.val(a),this},getFormattedDate:function(c){c===b&&(c=this.o.format);var d=this.o.language;return a.map(this.dates,function(a){return r.formatDate(a,c,d)}).join(this.o.multidateSeparator)},getStartDate:function(){return this.o.startDate},setStartDate:function(a){return this._process_options({startDate:a}),this.update(),this.updateNavArrows(),this},getEndDate:function(){return this.o.endDate},setEndDate:function(a){return this._process_options({endDate:a}),this.update(),this.updateNavArrows(),this},setDaysOfWeekDisabled:function(a){return this._process_options({daysOfWeekDisabled:a}),this.update(),this},setDaysOfWeekHighlighted:function(a){return this._process_options({daysOfWeekHighlighted:a}),this.update(),this},setDatesDisabled:function(a){return this._process_options({datesDisabled:a}),this.update(),this},place:function(){if(this.isInline)return this;var b=this.picker.outerWidth(),c=this.picker.outerHeight(),d=10,e=a(this.o.container),f=e.width(),g="body"===this.o.container?a(document).scrollTop():e.scrollTop(),h=e.offset(),i=[0];this.element.parents().each(function(){var b=a(this).css("z-index");"auto"!==b&&0!==Number(b)&&i.push(Number(b))});var j=Math.max.apply(Math,i)+this.o.zIndexOffset,k=this.component?this.component.parent().offset():this.element.offset(),l=this.component?this.component.outerHeight(!0):this.element.outerHeight(!1),m=this.component?this.component.outerWidth(!0):this.element.outerWidth(!1),n=k.left-h.left,o=k.top-h.top;"body"!==this.o.container&&(o+=g),this.picker.removeClass("datepicker-orient-top datepicker-orient-bottom datepicker-orient-right datepicker-orient-left"),"auto"!==this.o.orientation.x?(this.picker.addClass("datepicker-orient-"+this.o.orientation.x),"right"===this.o.orientation.x&&(n-=b-m)):k.left<0?(this.picker.addClass("datepicker-orient-left"),n-=k.left-d):n+b>f?(this.picker.addClass("datepicker-orient-right"),n+=m-b):this.o.rtl?this.picker.addClass("datepicker-orient-right"):this.picker.addClass("datepicker-orient-left");var p,q=this.o.orientation.y;if("auto"===q&&(p=-g+o-c,q=p<0?"bottom":"top"),this.picker.addClass("datepicker-orient-"+q),"top"===q?o-=c+parseInt(this.picker.css("padding-top")):o+=l,this.o.rtl){var r=f-(n+m);this.picker.css({top:o,right:r,zIndex:j})}else this.picker.css({top:o,left:n,zIndex:j});return this},_allow_update:!0,update:function(){if(!this._allow_update)return this;var b=this.dates.copy(),c=[],d=!1;return arguments.length?(a.each(arguments,a.proxy(function(a,b){b instanceof Date&&(b=this._local_to_utc(b)),c.push(b)},this)),d=!0):(c=this.isInput?this.element.val():this.element.data("date")||this.inputField.val(),c=c&&this.o.multidate?c.split(this.o.multidateSeparator):[c],delete this.element.data().date),c=a.map(c,a.proxy(function(a){return r.parseDate(a,this.o.format,this.o.language,this.o.assumeNearbyYear)},this)),c=a.grep(c,a.proxy(function(a){return!this.dateWithinRange(a)||!a},this),!0),this.dates.replace(c),this.o.updateViewDate&&(this.dates.length?this.viewDate=new Date(this.dates.get(-1)):this.viewDate<this.o.startDate?this.viewDate=new Date(this.o.startDate):this.viewDate>this.o.endDate?this.viewDate=new Date(this.o.endDate):this.viewDate=this.o.defaultViewDate),d?(this.setValue(),this.element.change()):this.dates.length&&String(b)!==String(this.dates)&&d&&(this._trigger("changeDate"),this.element.change()),!this.dates.length&&b.length&&(this._trigger("clearDate"),this.element.change()),this.fill(),this},fillDow:function(){if(this.o.showWeekDays){var b=this.o.weekStart,c="<tr>";for(this.o.calendarWeeks&&(c+='<th class="cw">&#160;</th>');b<this.o.weekStart+7;)c+='<th class="dow',a.inArray(b,this.o.daysOfWeekDisabled)!==-1&&(c+=" disabled"),c+='">'+q[this.o.language].daysMin[b++%7]+"</th>";c+="</tr>",this.picker.find(".datepicker-days thead").append(c)}},fillMonths:function(){for(var a,b=this._utc_to_local(this.viewDate),c="",d=0;d<12;d++)a=b&&b.getMonth()===d?" focused":"",c+='<span class="month'+a+'">'+q[this.o.language].monthsShort[d]+"</span>";this.picker.find(".datepicker-months td").html(c)},setRange:function(b){b&&b.length?this.range=a.map(b,function(a){return a.valueOf()}):delete this.range,this.fill()},getClassNames:function(b){var c=[],f=this.viewDate.getUTCFullYear(),g=this.viewDate.getUTCMonth(),h=d();return b.getUTCFullYear()<f||b.getUTCFullYear()===f&&b.getUTCMonth()<g?c.push("old"):(b.getUTCFullYear()>f||b.getUTCFullYear()===f&&b.getUTCMonth()>g)&&c.push("new"),this.focusDate&&b.valueOf()===this.focusDate.valueOf()&&c.push("focused"),this.o.todayHighlight&&e(b,h)&&c.push("today"),this.dates.contains(b)!==-1&&c.push("active"),this.dateWithinRange(b)||c.push("disabled"),this.dateIsDisabled(b)&&c.push("disabled","disabled-date"),a.inArray(b.getUTCDay(),this.o.daysOfWeekHighlighted)!==-1&&c.push("highlighted"),this.range&&(b>this.range[0]&&b<this.range[this.range.length-1]&&c.push("range"),a.inArray(b.valueOf(),this.range)!==-1&&c.push("selected"),b.valueOf()===this.range[0]&&c.push("range-start"),b.valueOf()===this.range[this.range.length-1]&&c.push("range-end")),c},_fill_yearsView:function(c,d,e,f,g,h,i){for(var j,k,l,m="",n=e/10,o=this.picker.find(c),p=Math.floor(f/e)*e,q=p+9*n,r=Math.floor(this.viewDate.getFullYear()/n)*n,s=a.map(this.dates,function(a){return Math.floor(a.getUTCFullYear()/n)*n}),t=p-n;t<=q+n;t+=n)j=[d],k=null,t===p-n?j.push("old"):t===q+n&&j.push("new"),a.inArray(t,s)!==-1&&j.push("active"),(t<g||t>h)&&j.push("disabled"),t===r&&j.push("focused"),i!==a.noop&&(l=i(new Date(t,0,1)),l===b?l={}:"boolean"==typeof l?l={enabled:l}:"string"==typeof l&&(l={classes:l}),l.enabled===!1&&j.push("disabled"),l.classes&&(j=j.concat(l.classes.split(/\s+/))),l.tooltip&&(k=l.tooltip)),m+='<span class="'+j.join(" ")+'"'+(k?' title="'+k+'"':"")+">"+t+"</span>";o.find(".datepicker-switch").text(p+"-"+q),o.find("td").html(m)},fill:function(){var d,e,f=new Date(this.viewDate),g=f.getUTCFullYear(),h=f.getUTCMonth(),i=this.o.startDate!==-(1/0)?this.o.startDate.getUTCFullYear():-(1/0),j=this.o.startDate!==-(1/0)?this.o.startDate.getUTCMonth():-(1/0),k=this.o.endDate!==1/0?this.o.endDate.getUTCFullYear():1/0,l=this.o.endDate!==1/0?this.o.endDate.getUTCMonth():1/0,m=q[this.o.language].today||q.en.today||"",n=q[this.o.language].clear||q.en.clear||"",o=q[this.o.language].titleFormat||q.en.titleFormat;if(!isNaN(g)&&!isNaN(h)){this.picker.find(".datepicker-days .datepicker-switch").text(r.formatDate(f,o,this.o.language)),this.picker.find("tfoot .today").text(m).css("display",this.o.todayBtn===!0||"linked"===this.o.todayBtn?"table-cell":"none"),this.picker.find("tfoot .clear").text(n).css("display",this.o.clearBtn===!0?"table-cell":"none"),this.picker.find("thead .datepicker-title").text(this.o.title).css("display","string"==typeof this.o.title&&""!==this.o.title?"table-cell":"none"),this.updateNavArrows(),this.fillMonths();var p=c(g,h,0),s=p.getUTCDate();p.setUTCDate(s-(p.getUTCDay()-this.o.weekStart+7)%7);var t=new Date(p);p.getUTCFullYear()<100&&t.setUTCFullYear(p.getUTCFullYear()),t.setUTCDate(t.getUTCDate()+42),t=t.valueOf();for(var u,v,w=[];p.valueOf()<t;){if(u=p.getUTCDay(),u===this.o.weekStart&&(w.push("<tr>"),this.o.calendarWeeks)){var x=new Date(+p+(this.o.weekStart-u-7)%7*864e5),y=new Date(Number(x)+(11-x.getUTCDay())%7*864e5),z=new Date(Number(z=c(y.getUTCFullYear(),0,1))+(11-z.getUTCDay())%7*864e5),A=(y-z)/864e5/7+1;w.push('<td class="cw">'+A+"</td>")}v=this.getClassNames(p),v.push("day");var B=p.getUTCDate();this.o.beforeShowDay!==a.noop&&(e=this.o.beforeShowDay(this._utc_to_local(p)),e===b?e={}:"boolean"==typeof e?e={enabled:e}:"string"==typeof e&&(e={classes:e}),e.enabled===!1&&v.push("disabled"),e.classes&&(v=v.concat(e.classes.split(/\s+/))),e.tooltip&&(d=e.tooltip),e.content&&(B=e.content)),v=a.isFunction(a.uniqueSort)?a.uniqueSort(v):a.unique(v),w.push('<td class="'+v.join(" ")+'"'+(d?' title="'+d+'"':"")+' data-date="'+p.getTime().toString()+'">'+B+"</td>"),d=null,u===this.o.weekEnd&&w.push("</tr>"),p.setUTCDate(p.getUTCDate()+1)}this.picker.find(".datepicker-days tbody").html(w.join(""));var C=q[this.o.language].monthsTitle||q.en.monthsTitle||"Months",D=this.picker.find(".datepicker-months").find(".datepicker-switch").text(this.o.maxViewMode<2?C:g).end().find("tbody span").removeClass("active");if(a.each(this.dates,function(a,b){b.getUTCFullYear()===g&&D.eq(b.getUTCMonth()).addClass("active")}),(g<i||g>k)&&D.addClass("disabled"),g===i&&D.slice(0,j).addClass("disabled"),g===k&&D.slice(l+1).addClass("disabled"),this.o.beforeShowMonth!==a.noop){var E=this;a.each(D,function(c,d){var e=new Date(g,c,1),f=E.o.beforeShowMonth(e);f===b?f={}:"boolean"==typeof f?f={enabled:f}:"string"==typeof f&&(f={classes:f}),f.enabled!==!1||a(d).hasClass("disabled")||a(d).addClass("disabled"),f.classes&&a(d).addClass(f.classes),f.tooltip&&a(d).prop("title",f.tooltip)})}this._fill_yearsView(".datepicker-years","year",10,g,i,k,this.o.beforeShowYear),this._fill_yearsView(".datepicker-decades","decade",100,g,i,k,this.o.beforeShowDecade),this._fill_yearsView(".datepicker-centuries","century",1e3,g,i,k,this.o.beforeShowCentury)}},updateNavArrows:function(){if(this._allow_update){var a,b,c=new Date(this.viewDate),d=c.getUTCFullYear(),e=c.getUTCMonth(),f=this.o.startDate!==-(1/0)?this.o.startDate.getUTCFullYear():-(1/0),g=this.o.startDate!==-(1/0)?this.o.startDate.getUTCMonth():-(1/0),h=this.o.endDate!==1/0?this.o.endDate.getUTCFullYear():1/0,i=this.o.endDate!==1/0?this.o.endDate.getUTCMonth():1/0,j=1;switch(this.viewMode){case 4:j*=10;case 3:j*=10;case 2:j*=10;case 1:a=Math.floor(d/j)*j<f,b=Math.floor(d/j)*j+j>h;break;case 0:a=d<=f&&e<g,b=d>=h&&e>i}this.picker.find(".prev").toggleClass("disabled",a),this.picker.find(".next").toggleClass("disabled",b)}},click:function(b){b.preventDefault(),b.stopPropagation();var e,f,g,h;e=a(b.target),e.hasClass("datepicker-switch")&&this.viewMode!==this.o.maxViewMode&&this.setViewMode(this.viewMode+1),e.hasClass("today")&&!e.hasClass("day")&&(this.setViewMode(0),this._setDate(d(),"linked"===this.o.todayBtn?null:"view")),e.hasClass("clear")&&this.clearDates(),e.hasClass("disabled")||(e.hasClass("month")||e.hasClass("year")||e.hasClass("decade")||e.hasClass("century"))&&(this.viewDate.setUTCDate(1),f=1,1===this.viewMode?(h=e.parent().find("span").index(e),g=this.viewDate.getUTCFullYear(),this.viewDate.setUTCMonth(h)):(h=0,g=Number(e.text()),this.viewDate.setUTCFullYear(g)),this._trigger(r.viewModes[this.viewMode-1].e,this.viewDate),this.viewMode===this.o.minViewMode?this._setDate(c(g,h,f)):(this.setViewMode(this.viewMode-1),this.fill())),this.picker.is(":visible")&&this._focused_from&&this._focused_from.focus(),delete this._focused_from},dayCellClick:function(b){var c=a(b.currentTarget),d=c.data("date"),e=new Date(d);this.o.updateViewDate&&(e.getUTCFullYear()!==this.viewDate.getUTCFullYear()&&this._trigger("changeYear",this.viewDate),e.getUTCMonth()!==this.viewDate.getUTCMonth()&&this._trigger("changeMonth",this.viewDate)),this._setDate(e)},navArrowsClick:function(b){var c=a(b.currentTarget),d=c.hasClass("prev")?-1:1;0!==this.viewMode&&(d*=12*r.viewModes[this.viewMode].navStep),this.viewDate=this.moveMonth(this.viewDate,d),this._trigger(r.viewModes[this.viewMode].e,this.viewDate),this.fill()},_toggle_multidate:function(a){var b=this.dates.contains(a);if(a||this.dates.clear(),b!==-1?(this.o.multidate===!0||this.o.multidate>1||this.o.toggleActive)&&this.dates.remove(b):this.o.multidate===!1?(this.dates.clear(),this.dates.push(a)):this.dates.push(a),"number"==typeof this.o.multidate)for(;this.dates.length>this.o.multidate;)this.dates.remove(0)},_setDate:function(a,b){b&&"date"!==b||this._toggle_multidate(a&&new Date(a)),(!b&&this.o.updateViewDate||"view"===b)&&(this.viewDate=a&&new Date(a)),this.fill(),this.setValue(),b&&"view"===b||this._trigger("changeDate"),this.inputField.trigger("change"),!this.o.autoclose||b&&"date"!==b||this.hide()},moveDay:function(a,b){var c=new Date(a);return c.setUTCDate(a.getUTCDate()+b),c},moveWeek:function(a,b){return this.moveDay(a,7*b)},moveMonth:function(a,b){if(!g(a))return this.o.defaultViewDate;if(!b)return a;var c,d,e=new Date(a.valueOf()),f=e.getUTCDate(),h=e.getUTCMonth(),i=Math.abs(b);if(b=b>0?1:-1,1===i)d=b===-1?function(){return e.getUTCMonth()===h}:function(){return e.getUTCMonth()!==c},c=h+b,e.setUTCMonth(c),c=(c+12)%12;else{for(var j=0;j<i;j++)e=this.moveMonth(e,b);c=e.getUTCMonth(),e.setUTCDate(f),d=function(){return c!==e.getUTCMonth()}}for(;d();)e.setUTCDate(--f),e.setUTCMonth(c);return e},moveYear:function(a,b){return this.moveMonth(a,12*b)},moveAvailableDate:function(a,b,c){do{if(a=this[c](a,b),!this.dateWithinRange(a))return!1;c="moveDay"}while(this.dateIsDisabled(a));return a},weekOfDateIsDisabled:function(b){return a.inArray(b.getUTCDay(),this.o.daysOfWeekDisabled)!==-1},dateIsDisabled:function(b){return this.weekOfDateIsDisabled(b)||a.grep(this.o.datesDisabled,function(a){return e(b,a)}).length>0},dateWithinRange:function(a){return a>=this.o.startDate&&a<=this.o.endDate},keydown:function(a){if(!this.picker.is(":visible"))return void(40!==a.keyCode&&27!==a.keyCode||(this.show(),a.stopPropagation()));var b,c,d=!1,e=this.focusDate||this.viewDate;switch(a.keyCode){case 27:this.focusDate?(this.focusDate=null,this.viewDate=this.dates.get(-1)||this.viewDate,this.fill()):this.hide(),a.preventDefault(),a.stopPropagation();break;case 37:case 38:case 39:case 40:if(!this.o.keyboardNavigation||7===this.o.daysOfWeekDisabled.length)break;b=37===a.keyCode||38===a.keyCode?-1:1,0===this.viewMode?a.ctrlKey?(c=this.moveAvailableDate(e,b,"moveYear"),c&&this._trigger("changeYear",this.viewDate)):a.shiftKey?(c=this.moveAvailableDate(e,b,"moveMonth"),c&&this._trigger("changeMonth",this.viewDate)):37===a.keyCode||39===a.keyCode?c=this.moveAvailableDate(e,b,"moveDay"):this.weekOfDateIsDisabled(e)||(c=this.moveAvailableDate(e,b,"moveWeek")):1===this.viewMode?(38!==a.keyCode&&40!==a.keyCode||(b*=4),c=this.moveAvailableDate(e,b,"moveMonth")):2===this.viewMode&&(38!==a.keyCode&&40!==a.keyCode||(b*=4),c=this.moveAvailableDate(e,b,"moveYear")),c&&(this.focusDate=this.viewDate=c,this.setValue(),this.fill(),a.preventDefault());break;case 13:if(!this.o.forceParse)break;e=this.focusDate||this.dates.get(-1)||this.viewDate,this.o.keyboardNavigation&&(this._toggle_multidate(e),d=!0),this.focusDate=null,this.viewDate=this.dates.get(-1)||this.viewDate,this.setValue(),this.fill(),this.picker.is(":visible")&&(a.preventDefault(),a.stopPropagation(),this.o.autoclose&&this.hide());break;case 9:this.focusDate=null,this.viewDate=this.dates.get(-1)||this.viewDate,this.fill(),this.hide()}d&&(this.dates.length?this._trigger("changeDate"):this._trigger("clearDate"),this.inputField.trigger("change"))},setViewMode:function(a){this.viewMode=a,this.picker.children("div").hide().filter(".datepicker-"+r.viewModes[this.viewMode].clsName).show(),this.updateNavArrows(),this._trigger("changeViewMode",new Date(this.viewDate))}};var l=function(b,c){a.data(b,"datepicker",this),this.element=a(b),this.inputs=a.map(c.inputs,function(a){return a.jquery?a[0]:a}),delete c.inputs,this.keepEmptyValues=c.keepEmptyValues,delete c.keepEmptyValues,n.call(a(this.inputs),c).on("changeDate",a.proxy(this.dateUpdated,this)),this.pickers=a.map(this.inputs,function(b){return a.data(b,"datepicker")}),this.updateDates()};l.prototype={updateDates:function(){this.dates=a.map(this.pickers,function(a){return a.getUTCDate()}),this.updateRanges()},updateRanges:function(){var b=a.map(this.dates,function(a){return a.valueOf()});a.each(this.pickers,function(a,c){c.setRange(b)})},clearDates:function(){a.each(this.pickers,function(a,b){b.clearDates()})},dateUpdated:function(c){if(!this.updating){this.updating=!0;var d=a.data(c.target,"datepicker");if(d!==b){var e=d.getUTCDate(),f=this.keepEmptyValues,g=a.inArray(c.target,this.inputs),h=g-1,i=g+1,j=this.inputs.length;if(g!==-1){if(a.each(this.pickers,function(a,b){b.getUTCDate()||b!==d&&f||b.setUTCDate(e)}),e<this.dates[h])for(;h>=0&&e<this.dates[h];)this.pickers[h--].setUTCDate(e);else if(e>this.dates[i])for(;i<j&&e>this.dates[i];)this.pickers[i++].setUTCDate(e);this.updateDates(),delete this.updating}}}},destroy:function(){a.map(this.pickers,function(a){a.destroy()}),a(this.inputs).off("changeDate",this.dateUpdated),delete this.element.data().datepicker},remove:f("destroy","Method `remove` is deprecated and will be removed in version 2.0. Use `destroy` instead")};var m=a.fn.datepicker,n=function(c){var d=Array.apply(null,arguments);d.shift();var e;if(this.each(function(){var b=a(this),f=b.data("datepicker"),g="object"==typeof c&&c;if(!f){var j=h(this,"date"),m=a.extend({},o,j,g),n=i(m.language),p=a.extend({},o,n,j,g);b.hasClass("input-daterange")||p.inputs?(a.extend(p,{inputs:p.inputs||b.find("input").toArray()}),f=new l(this,p)):f=new k(this,p),b.data("datepicker",f)}"string"==typeof c&&"function"==typeof f[c]&&(e=f[c].apply(f,d))}),e===b||e instanceof k||e instanceof l)return this;if(this.length>1)throw new Error("Using only allowed for the collection of a single element ("+c+" function)");return e};a.fn.datepicker=n;var o=a.fn.datepicker.defaults={assumeNearbyYear:!1,autoclose:!1,beforeShowDay:a.noop,beforeShowMonth:a.noop,beforeShowYear:a.noop,beforeShowDecade:a.noop,beforeShowCentury:a.noop,calendarWeeks:!1,clearBtn:!1,toggleActive:!1,daysOfWeekDisabled:[],daysOfWeekHighlighted:[],datesDisabled:[],endDate:1/0,forceParse:!0,format:"mm/dd/yyyy",keepEmptyValues:!1,keyboardNavigation:!0,language:"en",minViewMode:0,maxViewMode:4,multidate:!1,multidateSeparator:",",orientation:"auto",rtl:!1,startDate:-(1/0),startView:0,todayBtn:!1,todayHighlight:!1,updateViewDate:!0,weekStart:0,disableTouchKeyboard:!1,enableOnReadonly:!0,showOnFocus:!0,zIndexOffset:10,container:"body",immediateUpdates:!1,title:"",templates:{leftArrow:"&#x00AB;",rightArrow:"&#x00BB;"},showWeekDays:!0},p=a.fn.datepicker.locale_opts=["format","rtl","weekStart"];a.fn.datepicker.Constructor=k;var q=a.fn.datepicker.dates={en:{days:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],daysShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],daysMin:["Su","Mo","Tu","We","Th","Fr","Sa"],months:["January","February","March","April","May","June","July","August","September","October","November","December"],monthsShort:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],today:"Today",clear:"Clear",titleFormat:"MM yyyy"}},r={viewModes:[{names:["days","month"],clsName:"days",e:"changeMonth"},{names:["months","year"],clsName:"months",e:"changeYear",navStep:1},{names:["years","decade"],clsName:"years",e:"changeDecade",navStep:10},{names:["decades","century"],clsName:"decades",e:"changeCentury",navStep:100},{names:["centuries","millennium"],clsName:"centuries",e:"changeMillennium",navStep:1e3}],validParts:/dd?|DD?|mm?|MM?|yy(?:yy)?/g,nonpunctuation:/[^ -\/:-@\u5e74\u6708\u65e5\[-`{-~\t\n\r]+/g,parseFormat:function(a){if("function"==typeof a.toValue&&"function"==typeof a.toDisplay)return a;var b=a.replace(this.validParts,"\0").split("\0"),c=a.match(this.validParts);if(!b||!b.length||!c||0===c.length)throw new Error("Invalid date format.");return{separators:b,parts:c}},parseDate:function(c,e,f,g){function h(a,b){return b===!0&&(b=10),a<100&&(a+=2e3,a>(new Date).getFullYear()+b&&(a-=100)),a}function i(){var a=this.slice(0,j[n].length),b=j[n].slice(0,a.length);return a.toLowerCase()===b.toLowerCase()}if(!c)return b;if(c instanceof Date)return c;if("string"==typeof e&&(e=r.parseFormat(e)),e.toValue)return e.toValue(c,e,f);var j,l,m,n,o,p={d:"moveDay",m:"moveMonth",w:"moveWeek",y:"moveYear"},s={yesterday:"-1d",today:"+0d",tomorrow:"+1d"};if(c in s&&(c=s[c]),/^[\-+]\d+[dmwy]([\s,]+[\-+]\d+[dmwy])*$/i.test(c)){for(j=c.match(/([\-+]\d+)([dmwy])/gi),c=new Date,n=0;n<j.length;n++)l=j[n].match(/([\-+]\d+)([dmwy])/i),m=Number(l[1]),o=p[l[2].toLowerCase()],c=k.prototype[o](c,m);return k.prototype._zero_utc_time(c)}j=c&&c.match(this.nonpunctuation)||[];var t,u,v={},w=["yyyy","yy","M","MM","m","mm","d","dd"],x={yyyy:function(a,b){return a.setUTCFullYear(g?h(b,g):b)},m:function(a,b){if(isNaN(a))return a;for(b-=1;b<0;)b+=12;for(b%=12,a.setUTCMonth(b);a.getUTCMonth()!==b;)a.setUTCDate(a.getUTCDate()-1);return a},d:function(a,b){return a.setUTCDate(b)}};x.yy=x.yyyy,x.M=x.MM=x.mm=x.m,x.dd=x.d,c=d();var y=e.parts.slice();if(j.length!==y.length&&(y=a(y).filter(function(b,c){return a.inArray(c,w)!==-1}).toArray()),j.length===y.length){var z;for(n=0,z=y.length;n<z;n++){if(t=parseInt(j[n],10),l=y[n],isNaN(t))switch(l){case"MM":u=a(q[f].months).filter(i),t=a.inArray(u[0],q[f].months)+1;break;case"M":u=a(q[f].monthsShort).filter(i),t=a.inArray(u[0],q[f].monthsShort)+1}v[l]=t}var A,B;for(n=0;n<w.length;n++)B=w[n],B in v&&!isNaN(v[B])&&(A=new Date(c),x[B](A,v[B]),isNaN(A)||(c=A))}return c},formatDate:function(b,c,d){if(!b)return"";if("string"==typeof c&&(c=r.parseFormat(c)),c.toDisplay)return c.toDisplay(b,c,d);var e={d:b.getUTCDate(),D:q[d].daysShort[b.getUTCDay()],DD:q[d].days[b.getUTCDay()],m:b.getUTCMonth()+1,M:q[d].monthsShort[b.getUTCMonth()],MM:q[d].months[b.getUTCMonth()],yy:b.getUTCFullYear().toString().substring(2),yyyy:b.getUTCFullYear()};e.dd=(e.d<10?"0":"")+e.d,e.mm=(e.m<10?"0":"")+e.m,b=[];for(var f=a.extend([],c.separators),g=0,h=c.parts.length;g<=h;g++)f.length&&b.push(f.shift()),b.push(e[c.parts[g]]);return b.join("")},headTemplate:'<thead><tr><th colspan="7" class="datepicker-title"></th></tr><tr><th class="prev">'+o.templates.leftArrow+'</th><th colspan="5" class="datepicker-switch"></th><th class="next">'+o.templates.rightArrow+"</th></tr></thead>",
        contTemplate:'<tbody><tr><td colspan="7"></td></tr></tbody>',footTemplate:'<tfoot><tr><th colspan="7" class="today"></th></tr><tr><th colspan="7" class="clear"></th></tr></tfoot>'};r.template='<div class="datepicker"><div class="datepicker-days"><table class="table-condensed">'+r.headTemplate+"<tbody></tbody>"+r.footTemplate+'</table></div><div class="datepicker-months"><table class="table-condensed">'+r.headTemplate+r.contTemplate+r.footTemplate+'</table></div><div class="datepicker-years"><table class="table-condensed">'+r.headTemplate+r.contTemplate+r.footTemplate+'</table></div><div class="datepicker-decades"><table class="table-condensed">'+r.headTemplate+r.contTemplate+r.footTemplate+'</table></div><div class="datepicker-centuries"><table class="table-condensed">'+r.headTemplate+r.contTemplate+r.footTemplate+"</table></div></div>",a.fn.datepicker.DPGlobal=r,a.fn.datepicker.noConflict=function(){return a.fn.datepicker=m,this},a.fn.datepicker.version="1.8.0",a.fn.datepicker.deprecated=function(a){var b=window.console;b&&b.warn&&b.warn("DEPRECATED: "+a)},a(document).on("focus.datepicker.data-api click.datepicker.data-api",'[data-provide="datepicker"]',function(b){var c=a(this);c.data("datepicker")||(b.preventDefault(),n.call(c,"show"))}),a(function(){n.call(a('[data-provide="datepicker-inline"]'))})});

    !function(a){a.fn.datepicker.dates.et={days:["PÃ¼hapÃ¤ev","EsmaspÃ¤ev","TeisipÃ¤ev","KolmapÃ¤ev","NeljapÃ¤ev","Reede","LaupÃ¤ev"],daysShort:["PÃ¼hap","Esmasp","Teisip","Kolmap","Neljap","Reede","Laup"],daysMin:["P","E","T","K","N","R","L"],months:["Jaanuar","Veebruar","MÃ¤rts","Aprill","Mai","Juuni","Juuli","August","September","Oktoober","November","Detsember"],monthsShort:["Jaan","Veebr","MÃ¤rts","Apr","Mai","Juuni","Juuli","Aug","Sept","Okt","Nov","Dets"],today:"TÃ¤na",clear:"TÃ¼hjenda",weekStart:1,format:"dd.mm.yyyy"}}(jQuery);


    //carosel
    !function(i){"use strict";function s(s){s.each(function(){var s=i(this),t=s.data("animation");s.addClass(t).one("webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend",function(){s.removeClass(t)})})}var t=i(".carousel"),e=t.find(".item:first").find("[data-animation ^= 'animated']");t.carousel(),s(e),t.on("slide.bs.carousel",function(t){s(i(t.relatedTarget).find("[data-animation ^= 'animated']"))});for(var o=i(".carousel"),n=o.length,l=0;l<n;l++){i.fn.carousel.Constructor.TRANSITION_DURATION=9999999;var a=o.eq(l).data("duration"),r=i("[data-duration="+a+"] > .carousel-inner > .item");i(r).each(function(){i(this).css({"-webkit-transition-duration":a+"ms","-moz-transition-duration":a+"ms","transition-duration":a+"ms"})})}var c=i(".carousel").find("[class=mouse_wheel_y]");i(".carousel").find("[class=mouse_wheel_xy]")&&i(".mouse_wheel_xy").bind("mousewheel",function(s){s.originalEvent.wheelDelta/120>0?i(this).carousel("prev"):i(this).carousel("next")}),c&&i(".mouse_wheel_y").bind("mousewheel",function(s){s.originalEvent.wheelDelta/120>0&&i(this).carousel("next")});var u=i(".carousel").find("[class=swipe_y]"),h=i(".carousel").find("[class=swipe_x]");u&&i(".swipe_y .carousel-inner").swipe({swipeUp:function(s,t,e,o,n){i(this).parent().carousel("next")},swipeDown:function(){i(this).parent().carousel("prev")},threshold:0}),h&&i(".swipe_x .carousel-inner").swipe({swipeLeft:function(s,t,e,o,n){i(this).parent().carousel("next")},swipeRight:function(){i(this).parent().carousel("prev")},threshold:0});var d=0,m=0,_=i(".carousel").find("[class=thumb_scroll_y]"),f=i(".carousel").find("[class=thumb_scroll_x]");_&&i(".thumb_scroll_y").on("slid.bs.carousel",function(){var s=-1*i(".thumb_scroll_y .carousel-indicators li:first").position().top+i(".thumb_scroll_y .carousel-indicators li:last").position().top+i(".thumb_scroll_y .carousel-indicators li:last").height(),t=i(".thumb_scroll_y .carousel-indicators li.active").position().top+i(".thumb_scroll_y .carousel-indicators li.active").height()/1+d-i(".thumb_scroll_y .carousel-indicators").height()/1;t<0&&(t=0),t>s-i(".thumb_scroll_y .carousel-indicators").height()&&(t=s-i(".thumb_scroll_y .carousel-indicators").height()),i(".thumb_scroll_y .carousel-indicators").animate({scrollTop:t},800),d=t}),f&&i(".thumb_scroll_x").on("slid.bs.carousel",function(){var s=-1*i(".thumb_scroll_x .carousel-indicators li:first").position().left+i(".thumb_scroll_x .carousel-indicators li:last").position().left+i(".thumb_scroll_x .carousel-indicators li:last").width(),t=i(".thumb_scroll_x .carousel-indicators li.active").position().left+i(".thumb_scroll_x .carousel-indicators li.active").width()/1+m-i(".thumb_scroll_x .carousel-indicators").width()/1;t<0&&(t=0),t>s-i(".thumb_scroll_x .carousel-indicators").width()&&(t=s-i(".thumb_scroll_x .carousel-indicators").width()),i(".thumb_scroll_x .carousel-indicators").animate({scrollLeft:t},800),m=t}),i(".six_coloumns .item").each(function(){for(var s=i(this),t=1;t<6;t++)(s=s.next()).length||(s=i(this).siblings(":first")),s.children(":first-child").clone().addClass("cloneditem-"+t).appendTo(i(this))}),i(".five_coloumns .item").each(function(){for(var s=i(this),t=1;t<5;t++)(s=s.next()).length||(s=i(this).siblings(":first")),s.children(":first-child").clone().addClass("cloneditem-"+t).appendTo(i(this))}),i(".four_coloumns .item").each(function(){for(var s=i(this),t=1;t<4;t++)(s=s.next()).length||(s=i(this).siblings(":first")),s.children(":first-child").clone().addClass("cloneditem-"+t).appendTo(i(this))}),i(".three_coloumns .item").each(function(){for(var s=i(this),t=1;t<3;t++)(s=s.next()).length||(s=i(this).siblings(":first")),s.children(":first-child").clone().addClass("cloneditem-"+t).appendTo(i(this))}),i(".two_coloumns .item").each(function(){for(var s=i(this),t=1;t<2;t++)(s=s.next()).length||(s=i(this).siblings(":first")),s.children(":first-child").clone().addClass("cloneditem-"+t).appendTo(i(this))}),i(".pauseVideo").on("slide.bs.carousel",function(){i("video").each(function(){this.pause()})}),i(".onlinePauseVideo").on("slide.bs.carousel",function(s){i(s.target).find("iframe").each(function(s,t){i(t).attr("src",i(t).attr("src"))})});var p=i(".carousel.ps_full_screen > .carousel-inner > .item"),b=i(window).height();p.eq(0).addClass("active"),p.height(b),p.addClass("ps_full_s"),i(".carousel.ps_full_screen > .carousel-inner > .item > img").each(function(){var s=i(this).attr("src");i(this).parent().css({"background-image":"url("+s+")"}),i(this).remove()}),i(window).on("resize",function(){b=i(window).height(),p.height(b)})}(jQuery);


});
