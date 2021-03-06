(function (w) {
    var k = function (b, c) {
        typeof c == "undefined" && (c = {});
        this.init(b, c)
    }, a = k.prototype,
        o, p = ["canvas", "vml"],
        f = ["oval", "spiral", "square", "rect", "roundRect"],
        x = /^\#([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/,
        v = navigator.appVersion.indexOf("MSIE") !== -1 && parseFloat(navigator.appVersion.split("MSIE")[1]) === 8 ? true : false,
        y = !! document.createElement("canvas").getContext,
        q = true,
        n = function (b, c, a) {
            var b = document.createElement(b),
                d;
            for (d in a) b[d] = a[d];
            typeof c !== "undefined" && c.appendChild(b);
            return b
        }, m = function (b,
            c) {
            for (var a in c) b.style[a] = c[a];
            return b
        }, t = function (b, c) {
            for (var a in c) b.setAttribute(a, c[a]);
            return b
        }, u = function (b, c, a, d) {
            b.save();
            b.translate(c, a);
            b.rotate(d);
            b.translate(-c, -a);
            b.beginPath()
        };
    a.init = function (b, c) {
        if (typeof c.safeVML === "boolean") q = c.safeVML;
        try {
            this.mum = document.getElementById(b) !== void 0 ? document.getElementById(b) : document.body
        } catch (a) {
            this.mum = document.body
        }
        c.id = typeof c.id !== "undefined" ? c.id : "canvasLoader";
        this.cont = n("div", this.mum, {
            id: c.id
        });
        if (y) o = p[0], this.can = n("canvas",
            this.cont), this.con = this.can.getContext("2d"), this.cCan = m(n("canvas", this.cont), {
            display: "none"
        }), this.cCon = this.cCan.getContext("2d");
        else {
            o = p[1];
            if (typeof k.vmlSheet === "undefined") {
                document.getElementsByTagName("head")[0].appendChild(n("style"));
                k.vmlSheet = document.styleSheets[document.styleSheets.length - 1];
                var d = ["group", "oval", "roundrect", "fill"],
                    e;
                for (e in d) k.vmlSheet.addRule(d[e], "behavior:url(#default#VML); position:absolute;")
            }
            this.vml = n("group", this.cont)
        }
        this.setColor(this.color);
        this.draw();
        m(this.cont, {
            display: "none"
        })
    };
    a.cont = {};
    a.can = {};
    a.con = {};
    a.cCan = {};
    a.cCon = {};
    a.timer = {};
    a.activeId = 0;
    a.diameter = 40;
    a.setDiameter = function (b) {
        this.diameter = Math.round(Math.abs(b));
        this.redraw()
    };
    a.getDiameter = function () {
        return this.diameter
    };
    a.cRGB = {};
    a.color = "#000000";
    a.setColor = function (b) {
        this.color = x.test(b) ? b : "#000000";
        this.cRGB = this.getRGB(this.color);
        this.redraw()
    };
    a.getColor = function () {
        return this.color
    };
    a.shape = f[0];
    a.setShape = function (b) {
        for (var c in f)
            if (b === f[c]) {
                this.shape = b;
                this.redraw();
                break
            }
    };
    a.getShape = function () {
        return this.shape
    };
    a.density = 40;
    a.setDensity = function (b) {
        this.density = q && o === p[1] ? Math.round(Math.abs(b)) <= 40 ? Math.round(Math.abs(b)) : 40 : Math.round(Math.abs(b));
        if (this.density > 360) this.density = 360;
        this.activeId = 0;
        this.redraw()
    };
    a.getDensity = function () {
        return this.density
    };
    a.range = 1.3;
    a.setRange = function (b) {
        this.range = Math.abs(b);
        this.redraw()
    };
    a.getRange = function () {
        return this.range
    };
    a.speed = 2;
    a.setSpeed = function (b) {
        this.speed = Math.round(Math.abs(b))
    };
    a.getSpeed = function () {
        return this.speed
    };
    a.fps = 24;
    a.setFPS = function (b) {
        this.fps = Math.round(Math.abs(b));
        this.reset()
    };
    a.getFPS = function () {
        return this.fps
    };
    a.getRGB = function (b) {
        b = b.charAt(0) === "#" ? b.substring(1, 7) : b;
        return {
            r: parseInt(b.substring(0, 2), 16),
            g: parseInt(b.substring(2, 4), 16),
            b: parseInt(b.substring(4, 6), 16)
        }
    };
    a.draw = function () {
        var b = 0,
            c, a, d, e, h, k, j, r = this.density,
            s = Math.round(r * this.range),
            l, i, q = 0;
        i = this.cCon;
        var g = this.diameter;
        if (o === p[0]) {
            i.clearRect(0, 0, 1E3, 1E3);
            t(this.can, {
                width: g,
                height: g
            });
            for (t(this.cCan, {
                    width: g,
                    height: g
                }); b <
                r;) {
                l = b <= s ? 1 - 1 / s * b : l = 0;
                k = 270 - 360 / r * b;
                j = k / 180 * Math.PI;
                i.fillStyle = "rgba(" + this.cRGB.r + "," + this.cRGB.g + "," + this.cRGB.b + "," + l.toString() + ")";
                switch (this.shape) {
                case f[0]:
                case f[1]:
                    c = g * 0.07;
                    e = g * 0.47 + Math.cos(j) * (g * 0.47 - c) - g * 0.47;
                    h = g * 0.47 + Math.sin(j) * (g * 0.47 - c) - g * 0.47;
                    i.beginPath();
                    this.shape === f[1] ? i.arc(g * 0.5 + e, g * 0.5 + h, c * l, 0, Math.PI * 2, false) : i.arc(g * 0.5 + e, g * 0.5 + h, c, 0, Math.PI * 2, false);
                    break;
                case f[2]:
                    c = g * 0.12;
                    e = Math.cos(j) * (g * 0.47 - c) + g * 0.5;
                    h = Math.sin(j) * (g * 0.47 - c) + g * 0.5;
                    u(i, e, h, j);
                    i.fillRect(e, h - c * 0.5,
                        c, c);
                    break;
                case f[3]:
                case f[4]:
                    a = g * 0.3, d = a * 0.27, e = Math.cos(j) * (d + (g - d) * 0.13) + g * 0.5, h = Math.sin(j) * (d + (g - d) * 0.13) + g * 0.5, u(i, e, h, j), this.shape === f[3] ? i.fillRect(e, h - d * 0.5, a, d) : (c = d * 0.55, i.moveTo(e + c, h - d * 0.5), i.lineTo(e + a - c, h - d * 0.5), i.quadraticCurveTo(e + a, h - d * 0.5, e + a, h - d * 0.5 + c), i.lineTo(e + a, h - d * 0.5 + d - c), i.quadraticCurveTo(e + a, h - d * 0.5 + d, e + a - c, h - d * 0.5 + d), i.lineTo(e + c, h - d * 0.5 + d), i.quadraticCurveTo(e, h - d * 0.5 + d, e, h - d * 0.5 + d - c), i.lineTo(e, h - d * 0.5 + c), i.quadraticCurveTo(e, h - d * 0.5, e + c, h - d * 0.5))
                }
                i.closePath();
                i.fill();
                i.restore();
                ++b
            }
        } else {
            m(this.cont, {
                width: g,
                height: g
            });
            m(this.vml, {
                width: g,
                height: g
            });
            switch (this.shape) {
            case f[0]:
            case f[1]:
                j = "oval";
                c = 140;
                break;
            case f[2]:
                j = "roundrect";
                c = 120;
                break;
            case f[3]:
            case f[4]:
                j = "roundrect", c = 300
            }
            a = d = c;
            e = 500 - d;
            for (h = -d * 0.5; b < r;) {
                l = b <= s ? 1 - 1 / s * b : l = 0;
                k = 270 - 360 / r * b;
                switch (this.shape) {
                case f[1]:
                    a = d = c * l;
                    e = 500 - c * 0.5 - c * l * 0.5;
                    h = (c - c * l) * 0.5;
                    break;
                case f[0]:
                case f[2]:
                    v && (h = 0, this.shape === f[2] && (e = 500 - d * 0.5));
                    break;
                case f[3]:
                case f[4]:
                    a = c * 0.95, d = a * 0.28, v ? (e = 0, h = 500 - d * 0.5) : (e = 500 - a, h = -d * 0.5), q = this.shape === f[4] ? 0.6 : 0
                }
                i = t(m(n("group", this.vml), {
                    width: 1E3,
                    height: 1E3,
                    rotation: k
                }), {
                    coordsize: "1000,1000",
                    coordorigin: "-500,-500"
                });
                i = m(n(j, i, {
                    stroked: false,
                    arcSize: q
                }), {
                    width: a,
                    height: d,
                    top: h,
                    left: e
                });
                n("fill", i, {
                    color: this.color,
                    opacity: l
                });
                ++b
            }
        }
        this.tick(true)
    };
    a.clean = function () {
        if (o === p[0]) this.con.clearRect(0, 0, 1E3, 1E3);
        else {
            var b = this.vml;
            if (b.hasChildNodes())
                for (; b.childNodes.length >= 1;) b.removeChild(b.firstChild)
        }
    };
    a.redraw = function () {
        this.clean();
        this.draw()
    };
    a.reset = function () {
        typeof this.timer ===
            "number" && (this.hide(), this.show())
    };
    a.tick = function (b) {
        var a = this.con,
            f = this.diameter;
        b || (this.activeId += 360 / this.density * this.speed);
        o === p[0] ? (a.clearRect(0, 0, f, f), u(a, f * 0.5, f * 0.5, this.activeId / 180 * Math.PI), a.drawImage(this.cCan, 0, 0, f, f), a.restore()) : (this.activeId >= 360 && (this.activeId -= 360), m(this.vml, {
            rotation: this.activeId
        }))
    };
    a.show = function () {
        if (typeof this.timer !== "number") {
            var a = this;
            this.timer = self.setInterval(function () {
                a.tick()
            }, Math.round(1E3 / this.fps));
            m(this.cont, {
                display: "block"
            })
        }
    };
    a.hide = function () {
        typeof this.timer === "number" && (clearInterval(this.timer), delete this.timer, m(this.cont, {
            display: "none"
        }))
    };
    a.kill = function () {
        var a = this.cont;
        typeof this.timer === "number" && this.hide();
        o === p[0] ? (a.removeChild(this.can), a.removeChild(this.cCan)) : a.removeChild(this.vml);
        for (var c in this) delete this[c]
    };
    w.CanvasLoader = k
})(window);
(function ($) {
    var $scrollTo = $.scrollTo = function (target, duration, settings) {
        $(window).scrollTo(target, duration, settings)
    };
    $scrollTo.defaults = {
        axis: "xy",
        duration: parseFloat($.fn.jquery) >= 1.3 ? 0 : 1
    };
    $scrollTo.window = function (scope) {
        return $(window)._scrollable()
    };
    $.fn._scrollable = function () {
        return this.map(function () {
            var elem = this,
                isWin = !elem.nodeName || $.inArray(elem.nodeName.toLowerCase(), ["iframe", "#document", "html", "body"]) != -1;
            if (!isWin) return elem;
            var doc = (elem.contentWindow || elem).document || elem.ownerDocument ||
                elem;
            return $.browser.safari || doc.compatMode == "BackCompat" ? doc.body : doc.documentElement
        })
    };
    $.fn.scrollTo = function (target, duration, settings) {
        if (typeof duration == "object") {
            settings = duration;
            duration = 0
        }
        if (typeof settings == "function") settings = {
            onAfter: settings
        };
        if (target == "max") target = 9E9;
        settings = $.extend({}, $scrollTo.defaults, settings);
        duration = duration || settings.speed || settings.duration;
        settings.queue = settings.queue && settings.axis.length > 1;
        if (settings.queue) duration /= 2;
        settings.offset = both(settings.offset);
        settings.over = both(settings.over);
        return this._scrollable().each(function () {
            var elem = this,
                $elem = $(elem),
                targ = target,
                toff, attr = {}, win = $elem.is("html,body");
            switch (typeof targ) {
            case "number":
            case "string":
                if (/^([+-]=)?\d+(\.\d+)?(px|%)?$/.test(targ)) {
                    targ = both(targ);
                    break
                }
                targ = $(targ, this);
            case "object":
                if (targ.is || targ.style) toff = (targ = $(targ)).offset()
            }
            $.each(settings.axis.split(""), function (i, axis) {
                var Pos = axis == "x" ? "Left" : "Top",
                    pos = Pos.toLowerCase(),
                    key = "scroll" + Pos,
                    old = elem[key],
                    max = $scrollTo.max(elem,
                        axis);
                if (toff) {
                    attr[key] = toff[pos] + (win ? 0 : old - $elem.offset()[pos]);
                    if (settings.margin) {
                        attr[key] -= parseInt(targ.css("margin" + Pos)) || 0;
                        attr[key] -= parseInt(targ.css("border" + Pos + "Width")) || 0
                    }
                    attr[key] += settings.offset[pos] || 0;
                    if (settings.over[pos]) attr[key] += targ[axis == "x" ? "width" : "height"]() * settings.over[pos]
                } else {
                    var val = targ[pos];
                    if (val) attr[key] = val.slice && val.slice(-1) == "%" ? parseFloat(val) / 100 * max : val
                } if (/^\d+$/.test(attr[key])) attr[key] = attr[key] <= 0 ? 0 : Math.min(attr[key], max);
                if (!i && settings.queue) {
                    if (old !=
                        attr[key]) animate(settings.onAfterFirst);
                    delete attr[key]
                }
            });
            animate(settings.onAfter);

            function animate(callback) {
                $elem.animate(attr, duration, settings.easing, callback && function () {
                    callback.call(this, target, settings)
                })
            }
        }).end()
    };
    $scrollTo.max = function (elem, axis) {
        var Dim = axis == "x" ? "Width" : "Height",
            scroll = "scroll" + Dim;
        if (!$(elem).is("html,body")) return elem[scroll] - $(elem)[Dim.toLowerCase()]();
        var size = "client" + Dim,
            html = elem.ownerDocument.documentElement,
            body = elem.ownerDocument.body;
        return Math.max(html[scroll],
            body[scroll]) - Math.min(html[size], body[size])
    };

    function both(val) {
        return typeof val == "object" ? val : {
            top: val,
            left: val
        }
    }
})(jQuery);
(function (factory) {
    if (typeof define === "function" && define.amd) define(["jquery"], factory);
    else factory(jQuery)
})(function ($) {
    var d = [],
        doc = $(document),
        ua = navigator.userAgent.toLowerCase(),
        wndw = $(window),
        w = [];
    var browser = {
        ieQuirks: null,
        msie: /msie/.test(ua) && !/opera/.test(ua),
        opera: /opera/.test(ua)
    };
    browser.ie6 = browser.msie && /msie 6./.test(ua) && typeof window["XMLHttpRequest"] !== "object";
    browser.ie7 = browser.msie && /msie 7.0/.test(ua);
    $.modal = function (data, options) {
        return $.modal.impl.init(data, options)
    };
    $.modal.close = function () {
        $.modal.impl.close()
    };
    $.modal.focus = function (pos) {
        $.modal.impl.focus(pos)
    };
    $.modal.setContainerDimensions = function () {
        $.modal.impl.setContainerDimensions()
    };
    $.modal.setPosition = function () {
        $.modal.impl.setPosition()
    };
    $.modal.update = function (height, width) {
        $.modal.impl.update(height, width)
    };
    $.fn.modal = function (options) {
        return $.modal.impl.init(this, options)
    };
    $.modal.defaults = {
        appendTo: "body",
        focus: true,
        opacity: 50,
        overlayId: "simplemodal-overlay",
        overlayCss: {},
        containerId: "simplemodal-container",
        containerCss: {},
        dataId: "simplemodal-data",
        dataCss: {},
        minHeight: null,
        minWidth: null,
        maxHeight: null,
        maxWidth: null,
        autoResize: false,
        autoPosition: true,
        zIndex: 1E3,
        close: true,
        closeHTML: '<a class="modalCloseImg" title="Close"></a>',
        closeClass: "simplemodal-close",
        escClose: true,
        overlayClose: false,
        fixed: true,
        position: null,
        persist: false,
        modal: true,
        onOpen: null,
        onShow: null,
        onClose: null
    };
    $.modal.impl = {
        d: {},
        init: function (data, options) {
            var s = this;
            if (s.d.data) return false;
            browser.ieQuirks = browser.msie && !$.support.boxModel;
            s.o = $.extend({}, $.modal.defaults, options);
            s.zIndex = s.o.zIndex;
            s.occb = false;
            if (typeof data === "object") {
                data = data instanceof $ ? data : $(data);
                s.d.placeholder = false;
                if (data.parent().parent().size() > 0) {
                    data.before($("<span></span>").attr("id", "simplemodal-placeholder").css({
                        display: "none"
                    }));
                    s.d.placeholder = true;
                    s.display = data.css("display");
                    if (!s.o.persist) s.d.orig = data.clone(true)
                }
            } else if (typeof data === "string" || typeof data === "number") data = $("<div></div>").html(data);
            else {
                alert("SimpleModal Error: Unsupported data type: " +
                    typeof data);
                return s
            }
            s.create(data);
            data = null;
            s.open();
            if ($.isFunction(s.o.onShow)) s.o.onShow.apply(s, [s.d]);
            return s
        },
        create: function (data) {
            var s = this;
            s.getDimensions();
            if (s.o.modal && browser.ie6) s.d.iframe = $('<iframe src="javascript:false;"></iframe>').css($.extend(s.o.iframeCss, {
                display: "none",
                opacity: 0,
                position: "fixed",
                height: w[0],
                width: w[1],
                zIndex: s.o.zIndex,
                top: 0,
                left: 0
            })).appendTo(s.o.appendTo);
            s.d.overlay = $("<div></div>").attr("id", s.o.overlayId).addClass("simplemodal-overlay").css($.extend(s.o.overlayCss, {
                display: "none",
                opacity: s.o.opacity / 100,
                height: s.o.modal ? d[0] : 0,
                width: s.o.modal ? d[1] : 0,
                position: "fixed",
                left: 0,
                top: 0,
                zIndex: s.o.zIndex + 1
            })).appendTo(s.o.appendTo);
            s.d.container = $("<div></div>").attr("id", s.o.containerId).addClass("simplemodal-container").css($.extend({
                position: s.o.fixed ? "fixed" : "absolute"
            }, s.o.containerCss, {
                display: "none",
                zIndex: s.o.zIndex + 2
            })).append(s.o.close && s.o.closeHTML ? $(s.o.closeHTML).addClass(s.o.closeClass) : "").appendTo(s.o.appendTo);
            s.d.wrap = $("<div></div>").attr("tabIndex", -1).addClass("simplemodal-wrap").css({
                height: "100%",
                outline: 0,
                width: "100%"
            }).appendTo(s.d.container);
            s.d.data = data.attr("id", data.attr("id") || s.o.dataId).addClass("simplemodal-data").css($.extend(s.o.dataCss, {
                display: "none"
            })).appendTo("body");
            data = null;
            s.setContainerDimensions();
            s.d.data.appendTo(s.d.wrap);
            if (browser.ie6 || browser.ieQuirks) s.fixIE()
        },
        bindEvents: function () {
            var s = this;
            $("." + s.o.closeClass).bind("click.simplemodal", function (e) {
                e.preventDefault();
                s.close()
            });
            if (s.o.modal && s.o.close &&
                s.o.overlayClose) s.d.overlay.bind("click.simplemodal", function (e) {
                e.preventDefault();
                s.close()
            });
            doc.bind("keydown.simplemodal", function (e) {
                if (s.o.modal && e.keyCode === 9) s.watchTab(e);
                else if (s.o.close && s.o.escClose && e.keyCode === 27) {
                    e.preventDefault();
                    s.close()
                }
            });
            wndw.bind("resize.simplemodal orientationchange.simplemodal", function () {
                s.getDimensions();
                s.o.autoResize ? s.setContainerDimensions() : s.o.autoPosition && s.setPosition();
                if (browser.ie6 || browser.ieQuirks) s.fixIE();
                else if (s.o.modal) {
                    s.d.iframe &&
                        s.d.iframe.css({
                            height: w[0],
                            width: w[1]
                        });
                    s.d.overlay.css({
                        height: d[0],
                        width: d[1]
                    })
                }
            })
        },
        unbindEvents: function () {
            $("." + this.o.closeClass).unbind("click.simplemodal");
            doc.unbind("keydown.simplemodal");
            wndw.unbind(".simplemodal");
            this.d.overlay.unbind("click.simplemodal")
        },
        fixIE: function () {
            var s = this,
                p = s.o.position;
            $.each([s.d.iframe || null, !s.o.modal ? null : s.d.overlay, s.d.container.css("position") === "fixed" ? s.d.container : null], function (i, el) {
                if (el) {
                    var bch = "document.body.clientHeight",
                        bcw = "document.body.clientWidth",
                        bsh = "document.body.scrollHeight",
                        bsl = "document.body.scrollLeft",
                        bst = "document.body.scrollTop",
                        bsw = "document.body.scrollWidth",
                        ch = "document.documentElement.clientHeight",
                        cw = "document.documentElement.clientWidth",
                        sl = "document.documentElement.scrollLeft",
                        st = "document.documentElement.scrollTop",
                        s = el[0].style;
                    s.position = "absolute";
                    if (i < 2) {
                        s.removeExpression("height");
                        s.removeExpression("width");
                        s.setExpression("height", "" + bsh + " > " + bch + " ? " + bsh + " : " + bch + ' + "px"');
                        s.setExpression("width", "" + bsw + " > " +
                            bcw + " ? " + bsw + " : " + bcw + ' + "px"')
                    } else {
                        var te, le;
                        if (p && p.constructor === Array) {
                            var top = p[0] ? typeof p[0] === "number" ? p[0].toString() : p[0].replace(/px/, "") : el.css("top").replace(/px/, "");
                            te = top.indexOf("%") === -1 ? top + " + (t = " + st + " ? " + st + " : " + bst + ') + "px"' : parseInt(top.replace(/%/, "")) + " * ((" + ch + " || " + bch + ") / 100) + (t = " + st + " ? " + st + " : " + bst + ') + "px"';
                            if (p[1]) {
                                var left = typeof p[1] === "number" ? p[1].toString() : p[1].replace(/px/, "");
                                le = left.indexOf("%") === -1 ? left + " + (t = " + sl + " ? " + sl + " : " + bsl +
                                    ') + "px"' : parseInt(left.replace(/%/, "")) + " * ((" + cw + " || " + bcw + ") / 100) + (t = " + sl + " ? " + sl + " : " + bsl + ') + "px"'
                            }
                        } else {
                            te = "(" + ch + " || " + bch + ") / 2 - (this.offsetHeight / 2) + (t = " + st + " ? " + st + " : " + bst + ') + "px"';
                            le = "(" + cw + " || " + bcw + ") / 2 - (this.offsetWidth / 2) + (t = " + sl + " ? " + sl + " : " + bsl + ') + "px"'
                        }
                        s.removeExpression("top");
                        s.removeExpression("left");
                        s.setExpression("top", te);
                        s.setExpression("left", le)
                    }
                }
            })
        },
        focus: function (pos) {
            var s = this,
                p = pos && $.inArray(pos, ["first", "last"]) !== -1 ? pos :
                    "first";
            var input = $(":input:enabled:visible:" + p, s.d.wrap);
            setTimeout(function () {
                input.length > 0 ? input.focus() : s.d.wrap.focus()
            }, 10)
        },
        getDimensions: function () {
            var s = this,
                h = typeof window.innerHeight === "undefined" ? wndw.height() : window.innerHeight;
            d = [doc.height(), doc.width()];
            w = [h, wndw.width()]
        },
        getVal: function (v, d) {
            return v ? typeof v === "number" ? v : v === "auto" ? 0 : v.indexOf("%") > 0 ? parseInt(v.replace(/%/, "")) / 100 * (d === "h" ? w[0] : w[1]) : parseInt(v.replace(/px/, "")) : null
        },
        update: function (height, width) {
            var s = this;
            if (!s.d.data) return false;
            s.d.origHeight = s.getVal(height, "h");
            s.d.origWidth = s.getVal(width, "w");
            s.d.data.hide();
            height && s.d.container.css("height", height);
            width && s.d.container.css("width", width);
            s.setContainerDimensions();
            s.d.data.show();
            s.o.focus && s.focus();
            s.unbindEvents();
            s.bindEvents()
        },
        setContainerDimensions: function () {
            var s = this,
                badIE = browser.ie6 || browser.ie7;
            var ch = s.d.origHeight ? s.d.origHeight : browser.opera ? s.d.container.height() : s.getVal(badIE ? s.d.container[0].currentStyle["height"] : s.d.container.css("height"),
                "h"),
                cw = s.d.origWidth ? s.d.origWidth : browser.opera ? s.d.container.width() : s.getVal(badIE ? s.d.container[0].currentStyle["width"] : s.d.container.css("width"), "w"),
                dh = s.d.data.outerHeight(true),
                dw = s.d.data.outerWidth(true);
            s.d.origHeight = s.d.origHeight || ch;
            s.d.origWidth = s.d.origWidth || cw;
            var mxoh = s.o.maxHeight ? s.getVal(s.o.maxHeight, "h") : null,
                mxow = s.o.maxWidth ? s.getVal(s.o.maxWidth, "w") : null,
                mh = mxoh && mxoh < w[0] ? mxoh : w[0],
                mw = mxow && mxow < w[1] ? mxow : w[1];
            var moh = s.o.minHeight ? s.getVal(s.o.minHeight, "h") : "auto";
            if (!ch)
                if (!dh) ch = moh;
                else if (dh > mh) ch = mh;
            else if (s.o.minHeight && moh !== "auto" && dh < moh) ch = moh;
            else ch = dh;
            else ch = s.o.autoResize && ch > mh ? mh : ch < moh ? moh : ch;
            var mow = s.o.minWidth ? s.getVal(s.o.minWidth, "w") : "auto";
            if (!cw)
                if (!dw) cw = mow;
                else if (dw > mw) cw = mw;
            else if (s.o.minWidth && mow !== "auto" && dw < mow) cw = mow;
            else cw = dw;
            else cw = s.o.autoResize && cw > mw ? mw : cw < mow ? mow : cw;
            s.d.container.css({
                height: ch,
                width: cw
            });
            s.d.wrap.css({
                overflow: dh > ch || dw > cw ? "auto" : "visible"
            });
            s.o.autoPosition && s.setPosition()
        },
        setPosition: function () {
            var s =
                this,
                top, left, hc = w[0] / 2 - s.d.container.outerHeight(true) / 2,
                vc = w[1] / 2 - s.d.container.outerWidth(true) / 2,
                st = s.d.container.css("position") !== "fixed" ? wndw.scrollTop() : 0;
            if (s.o.position && Object.prototype.toString.call(s.o.position) === "[object Array]") {
                top = st + (s.o.position[0] || hc);
                left = s.o.position[1] || vc
            } else {
                top = st + hc;
                left = vc
            }
            s.d.container.css({
                left: left,
                top: top
            })
        },
        watchTab: function (e) {
            var s = this;
            if ($(e.target).parents(".simplemodal-container").length > 0) {
                s.inputs = $(":input:enabled:visible:first, :input:enabled:visible:last",
                    s.d.data[0]);
                if (!e.shiftKey && e.target === s.inputs[s.inputs.length - 1] || e.shiftKey && e.target === s.inputs[0] || s.inputs.length === 0) {
                    e.preventDefault();
                    var pos = e.shiftKey ? "last" : "first";
                    s.focus(pos)
                }
            } else {
                e.preventDefault();
                s.focus()
            }
        },
        open: function () {
            var s = this;
            s.d.iframe && s.d.iframe.show();
            if ($.isFunction(s.o.onOpen)) s.o.onOpen.apply(s, [s.d]);
            else {
                s.d.overlay.show();
                s.d.container.show();
                s.d.data.show()
            }
            s.o.focus && s.focus();
            s.bindEvents()
        },
        close: function () {
            var s = this;
            if (!s.d.data) return false;
            s.unbindEvents();
            if ($.isFunction(s.o.onClose) && !s.occb) {
                s.occb = true;
                s.o.onClose.apply(s, [s.d])
            } else {
                if (s.d.placeholder) {
                    var ph = $("#simplemodal-placeholder");
                    if (s.o.persist) ph.replaceWith(s.d.data.removeClass("simplemodal-data").css("display", s.display));
                    else {
                        s.d.data.hide().remove();
                        ph.replaceWith(s.d.orig)
                    }
                } else s.d.data.hide().remove();
                s.d.container.hide().remove();
                s.d.overlay.hide();
                s.d.iframe && s.d.iframe.hide().remove();
                s.d.overlay.remove();
                s.d = {}
            }
        }
    }
});
(function (b, a, c) {
    b.fn.jScrollPane = function (e) {
        function d(D, O) {
            var ay, Q = this,
                Y, aj, v, al, T, Z, y, q, az, aE, au, i, I, h, j, aa, U, ap, X, t, A, aq, af, am, G, l, at, ax, x, av, aH, f, L, ai = true,
                P = true,
                aG = false,
                k = false,
                ao = D.clone(false, false).empty(),
                ac = b.fn.mwheelIntent ? "mwheelIntent.jsp" : "mousewheel.jsp";
            aH = D.css("paddingTop") + " " + D.css("paddingRight") + " " + D.css("paddingBottom") + " " + D.css("paddingLeft");
            f = (parseInt(D.css("paddingLeft"), 10) || 0) + (parseInt(D.css("paddingRight"), 10) || 0);

            function ar(aQ) {
                var aL, aN, aM, aJ, aI, aP, aO = false,
                    aK = false;
                ay = aQ;
                if (Y === c) {
                    aI = D.scrollTop();
                    aP = D.scrollLeft();
                    D.css({
                        overflow: "hidden",
                        padding: 0
                    });
                    aj = D.innerWidth() + f;
                    v = D.innerHeight();
                    D.width(aj);
                    Y = b('<div class="jspPane" />').css("padding", aH).append(D.children());
                    al = b('<div class="jspContainer" />').css({
                        width: aj + "px",
                        height: v + "px"
                    }).append(Y).appendTo(D)
                } else {
                    D.css("width", "");
                    aO = ay.stickToBottom && K();
                    aK = ay.stickToRight && B();
                    aJ = D.innerWidth() + f != aj || D.outerHeight() != v;
                    if (aJ) {
                        aj = D.innerWidth() + f;
                        v = D.innerHeight();
                        al.css({
                            width: aj + "px",
                            height: v + "px"
                        })
                    }
                    if (!aJ && L == T && Y.outerHeight() == Z) {
                        D.width(aj);
                        return
                    }
                    L = T;
                    Y.css("width", "");
                    D.width(aj);
                    al.find(">.jspVerticalBar,>.jspHorizontalBar").remove().end()
                }
                Y.css("overflow", "auto");
                if (aQ.contentWidth) {
                    T = aQ.contentWidth
                } else {
                    T = Y[0].scrollWidth
                }
                Z = Y[0].scrollHeight;
                Y.css("overflow", "");
                y = T / aj;
                q = Z / v;
                az = q > 1;
                aE = y > 1;
                if (!(aE || az)) {
                    D.removeClass("jspScrollable");
                    Y.css({
                        top: 0,
                        width: al.width() - f
                    });
                    n();
                    E();
                    R();
                    w()
                } else {
                    D.addClass("jspScrollable");
                    aL = ay.maintainPosition && (I || aa);
                    if (aL) {
                        aN = aC();
                        aM = aA()
                    }
                    aF();
                    z();
                    F();
                    if (aL) {
                        N(aK ? (T - aj) : aN, false);
                        M(aO ? (Z - v) : aM, false)
                    }
                    J();
                    ag();
                    an();
                    if (ay.enableKeyboardNavigation) {
                        S()
                    }
                    if (ay.clickOnTrack) {
                        p()
                    }
                    C();
                    if (ay.hijackInternalLinks) {
                        m()
                    }
                } if (ay.autoReinitialise && !av) {
                    av = setInterval(function () {
                        ar(ay)
                    }, ay.autoReinitialiseDelay)
                } else {
                    if (!ay.autoReinitialise && av) {
                        clearInterval(av)
                    }
                }
                aI && D.scrollTop(0) && M(aI, false);
                aP && D.scrollLeft(0) && N(aP, false);
                D.trigger("jsp-initialised", [aE || az])
            }

            function aF() {
                if (az) {
                    al.append(b('<div class="jspVerticalBar" />').append(b('<div class="jspCap jspCapTop" />'), b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragTop" />'), b('<div class="jspDragBottom" />'))), b('<div class="jspCap jspCapBottom" />')));
                    U = al.find(">.jspVerticalBar");
                    ap = U.find(">.jspTrack");
                    au = ap.find(">.jspDrag");
                    if (ay.showArrows) {
                        aq = b('<a class="jspArrow jspArrowUp" />').bind("mousedown.jsp", aD(0, -1)).bind("click.jsp", aB);
                        af = b('<a class="jspArrow jspArrowDown" />').bind("mousedown.jsp", aD(0, 1)).bind("click.jsp", aB);
                        if (ay.arrowScrollOnHover) {
                            aq.bind("mouseover.jsp", aD(0, -1, aq));
                            af.bind("mouseover.jsp", aD(0, 1, af))
                        }
                        ak(ap, ay.verticalArrowPositions, aq, af)
                    }
                    t = v;
                    al.find(">.jspVerticalBar>.jspCap:visible,>.jspVerticalBar>.jspArrow").each(function () {
                        t -= b(this).outerHeight()
                    });
                    au.hover(function () {
                        au.addClass("jspHover")
                    }, function () {
                        au.removeClass("jspHover")
                    }).bind("mousedown.jsp", function (aI) {
                        b("html").bind("dragstart.jsp selectstart.jsp", aB);
                        au.addClass("jspActive");
                        var s = aI.pageY - au.position().top;
                        b("html").bind("mousemove.jsp", function (aJ) {
                            V(aJ.pageY - s, false)
                        }).bind("mouseup.jsp mouseleave.jsp", aw);
                        return false
                    });
                    o()
                }
            }

            function o() {
                ap.height(t + "px");
                I = 0;
                X = ay.verticalGutter + ap.outerWidth();
                Y.width(aj - X - f);
                try {
                    if (U.position().left === 0) {
                        Y.css("margin-left", X + "px")
                    }
                } catch (s) {}
            }

            function z() {
                if (aE) {
                    al.append(b('<div class="jspHorizontalBar" />').append(b('<div class="jspCap jspCapLeft" />'), b('<div class="jspTrack" />').append(b('<div class="jspDrag" />').append(b('<div class="jspDragLeft" />'), b('<div class="jspDragRight" />'))), b('<div class="jspCap jspCapRight" />')));
                    am = al.find(">.jspHorizontalBar");
                    G = am.find(">.jspTrack");
                    h = G.find(">.jspDrag");
                    if (ay.showArrows) {
                        ax = b('<a class="jspArrow jspArrowLeft" />').bind("mousedown.jsp", aD(-1, 0)).bind("click.jsp", aB);
                        x = b('<a class="jspArrow jspArrowRight" />').bind("mousedown.jsp", aD(1, 0)).bind("click.jsp", aB);
                        if (ay.arrowScrollOnHover) {
                            ax.bind("mouseover.jsp", aD(-1, 0, ax));
                            x.bind("mouseover.jsp", aD(1, 0, x))
                        }
                        ak(G, ay.horizontalArrowPositions, ax, x)
                    }
                    h.hover(function () {
                        h.addClass("jspHover")
                    }, function () {
                        h.removeClass("jspHover")
                    }).bind("mousedown.jsp", function (aI) {
                        b("html").bind("dragstart.jsp selectstart.jsp", aB);
                        h.addClass("jspActive");
                        var s = aI.pageX - h.position().left;
                        b("html").bind("mousemove.jsp", function (aJ) {
                            W(aJ.pageX - s, false)
                        }).bind("mouseup.jsp mouseleave.jsp", aw);
                        return false
                    });
                    l = al.innerWidth();
                    ah()
                }
            }

            function ah() {
                al.find(">.jspHorizontalBar>.jspCap:visible,>.jspHorizontalBar>.jspArrow").each(function () {
                    l -= b(this).outerWidth()
                });
                G.width(l + "px");
                aa = 0
            }

            function F() {
                if (aE && az) {
                    var aI = G.outerHeight(),
                        s = ap.outerWidth();
                    t -= aI;
                    b(am).find(">.jspCap:visible,>.jspArrow").each(function () {
                        l += b(this).outerWidth()
                    });
                    l -= s;
                    v -= s;
                    aj -= aI;
                    G.parent().append(b('<div class="jspCorner" />').css("width", aI + "px"));
                    o();
                    ah()
                }
                if (aE) {
                    Y.width((al.outerWidth() - f) + "px")
                }
                Z = Y.outerHeight();
                q = Z / v;
                if (aE) {
                    at = Math.ceil(1 / y * l);
                    if (at > ay.horizontalDragMaxWidth) {
                        at = ay.horizontalDragMaxWidth
                    } else {
                        if (at < ay.horizontalDragMinWidth) {
                            at = ay.horizontalDragMinWidth
                        }
                    }
                    h.width(at + "px");
                    j = l - at;
                    ae(aa)
                }
                if (az) {
                    A = Math.ceil(1 / q * t);
                    if (A > ay.verticalDragMaxHeight) {
                        A = ay.verticalDragMaxHeight
                    } else {
                        if (A < ay.verticalDragMinHeight) {
                            A = ay.verticalDragMinHeight
                        }
                    }
                    au.height(A + "px");
                    i = t - A;
                    ad(I)
                }
            }

            function ak(aJ, aL, aI, s) {
                var aN = "before",
                    aK = "after",
                    aM;
                if (aL == "os") {
                    aL = /Mac/.test(navigator.platform) ? "after" : "split"
                }
                if (aL == aN) {
                    aK = aL
                } else {
                    if (aL == aK) {
                        aN = aL;
                        aM = aI;
                        aI = s;
                        s = aM
                    }
                }
                aJ[aN](aI)[aK](s)
            }

            function aD(aI, s, aJ) {
                return function () {
                    H(aI, s, this, aJ);
                    this.blur();
                    return false
                }
            }

            function H(aL, aK, aO, aN) {
                aO = b(aO).addClass("jspActive");
                var aM, aJ, aI = true,
                    s = function () {
                        if (aL !== 0) {
                            Q.scrollByX(aL * ay.arrowButtonSpeed)
                        }
                        if (aK !== 0) {
                            Q.scrollByY(aK * ay.arrowButtonSpeed)
                        }
                        aJ = setTimeout(s, aI ? ay.initialDelay : ay.arrowRepeatFreq);
                        aI = false
                    };
                s();
                aM = aN ? "mouseout.jsp" : "mouseup.jsp";
                aN = aN || b("html");
                aN.bind(aM, function () {
                    aO.removeClass("jspActive");
                    aJ && clearTimeout(aJ);
                    aJ = null;
                    aN.unbind(aM)
                })
            }

            function p() {
                w();
                if (az) {
                    ap.bind("mousedown.jsp", function (aN) {
                        if (aN.originalTarget === c || aN.originalTarget == aN.currentTarget) {
                            var aL = b(this),
                                aO = aL.offset(),
                                aM = aN.pageY - aO.top - I,
                                aJ, aI = true,
                                s = function () {
                                    var aR = aL.offset(),
                                        aS = aN.pageY - aR.top - A / 2,
                                        aP = v * ay.scrollPagePercent,
                                        aQ = i * aP / (Z - v);
                                    if (aM < 0) {
                                        if (I - aQ > aS) {
                                            Q.scrollByY(-aP)
                                        } else {
                                            V(aS)
                                        }
                                    } else {
                                        if (aM > 0) {
                                            if (I + aQ < aS) {
                                                Q.scrollByY(aP)
                                            } else {
                                                V(aS)
                                            }
                                        } else {
                                            aK();
                                            return
                                        }
                                    }
                                    aJ = setTimeout(s, aI ? ay.initialDelay : ay.trackClickRepeatFreq);
                                    aI = false
                                }, aK = function () {
                                    aJ && clearTimeout(aJ);
                                    aJ = null;
                                    b(document).unbind("mouseup.jsp", aK)
                                };
                            s();
                            b(document).bind("mouseup.jsp", aK);
                            return false
                        }
                    })
                }
                if (aE) {
                    G.bind("mousedown.jsp", function (aN) {
                        if (aN.originalTarget === c || aN.originalTarget == aN.currentTarget) {
                            var aL = b(this),
                                aO = aL.offset(),
                                aM = aN.pageX - aO.left - aa,
                                aJ, aI = true,
                                s = function () {
                                    var aR = aL.offset(),
                                        aS = aN.pageX - aR.left - at / 2,
                                        aP = aj * ay.scrollPagePercent,
                                        aQ = j * aP / (T - aj);
                                    if (aM < 0) {
                                        if (aa - aQ > aS) {
                                            Q.scrollByX(-aP)
                                        } else {
                                            W(aS)
                                        }
                                    } else {
                                        if (aM > 0) {
                                            if (aa + aQ < aS) {
                                                Q.scrollByX(aP)
                                            } else {
                                                W(aS)
                                            }
                                        } else {
                                            aK();
                                            return
                                        }
                                    }
                                    aJ = setTimeout(s, aI ? ay.initialDelay : ay.trackClickRepeatFreq);
                                    aI = false
                                }, aK = function () {
                                    aJ && clearTimeout(aJ);
                                    aJ = null;
                                    b(document).unbind("mouseup.jsp", aK)
                                };
                            s();
                            b(document).bind("mouseup.jsp", aK);
                            return false
                        }
                    })
                }
            }

            function w() {
                if (G) {
                    G.unbind("mousedown.jsp")
                }
                if (ap) {
                    ap.unbind("mousedown.jsp")
                }
            }

            function aw() {
                b("html").unbind("dragstart.jsp selectstart.jsp mousemove.jsp mouseup.jsp mouseleave.jsp");
                if (au) {
                    au.removeClass("jspActive")
                }
                if (h) {
                    h.removeClass("jspActive")
                }
            }

            function V(s, aI) {
                if (!az) {
                    return
                }
                if (s < 0) {
                    s = 0
                } else {
                    if (s > i) {
                        s = i
                    }
                } if (aI === c) {
                    aI = ay.animateScroll
                }
                if (aI) {
                    Q.animate(au, "top", s, ad)
                } else {
                    au.css("top", s);
                    ad(s)
                }
            }

            function ad(aI) {
                if (aI === c) {
                    aI = au.position().top
                }
                al.scrollTop(0);
                I = aI;
                var aL = I === 0,
                    aJ = I == i,
                    aK = aI / i,
                    s = -aK * (Z - v);
                if (ai != aL || aG != aJ) {
                    ai = aL;
                    aG = aJ;
                    D.trigger("jsp-arrow-change", [ai, aG, P, k])
                }
                u(aL, aJ);
                Y.css("top", s);
                D.trigger("jsp-scroll-y", [-s, aL, aJ]).trigger("scroll")
            }

            function W(aI, s) {
                if (!aE) {
                    return
                }
                if (aI < 0) {
                    aI = 0
                } else {
                    if (aI > j) {
                        aI = j
                    }
                } if (s === c) {
                    s = ay.animateScroll
                }
                if (s) {
                    Q.animate(h, "left", aI, ae)
                } else {
                    h.css("left", aI);
                    ae(aI)
                }
            }

            function ae(aI) {
                if (aI === c) {
                    aI = h.position().left
                }
                al.scrollTop(0);
                aa = aI;
                var aL = aa === 0,
                    aK = aa == j,
                    aJ = aI / j,
                    s = -aJ * (T - aj);
                if (P != aL || k != aK) {
                    P = aL;
                    k = aK;
                    D.trigger("jsp-arrow-change", [ai, aG, P, k])
                }
                r(aL, aK);
                Y.css("left", s);
                D.trigger("jsp-scroll-x", [-s, aL, aK]).trigger("scroll")
            }

            function u(aI, s) {
                if (ay.showArrows) {
                    aq[aI ? "addClass" : "removeClass"]("jspDisabled");
                    af[s ? "addClass" : "removeClass"]("jspDisabled")
                }
            }

            function r(aI, s) {
                if (ay.showArrows) {
                    ax[aI ? "addClass" : "removeClass"]("jspDisabled");
                    x[s ? "addClass" : "removeClass"]("jspDisabled")
                }
            }

            function M(s, aI) {
                var aJ = s / (Z - v);
                V(aJ * i, aI)
            }

            function N(aI, s) {
                var aJ = aI / (T - aj);
                W(aJ * j, s)
            }

            function ab(aV, aQ, aJ) {
                var aN, aK, aL, s = 0,
                    aU = 0,
                    aI, aP, aO, aS, aR, aT;
                try {
                    aN = b(aV)
                } catch (aM) {
                    return
                }
                aK = aN.outerHeight();
                aL = aN.outerWidth();
                al.scrollTop(0);
                al.scrollLeft(0);
                while (!aN.is(".jspPane")) {
                    s += aN.position().top;
                    aU += aN.position().left;
                    aN = aN.offsetParent();
                    if (/^body|html$/i.test(aN[0].nodeName)) {
                        return
                    }
                }
                aI = aA();
                aO = aI + v;
                if (s < aI || aQ) {
                    aR = s - ay.verticalGutter
                } else {
                    if (s + aK > aO) {
                        aR = s - v + aK + ay.verticalGutter
                    }
                } if (aR) {
                    M(aR, aJ)
                }
                aP = aC();
                aS = aP + aj;
                if (aU < aP || aQ) {
                    aT = aU - ay.horizontalGutter
                } else {
                    if (aU + aL > aS) {
                        aT = aU - aj + aL + ay.horizontalGutter
                    }
                } if (aT) {
                    N(aT, aJ)
                }
            }

            function aC() {
                return -Y.position().left
            }

            function aA() {
                return -Y.position().top
            }

            function K() {
                var s = Z - v;
                return (s > 20) && (s - aA() < 10)
            }

            function B() {
                var s = T - aj;
                return (s > 20) && (s - aC() < 10)
            }

            function ag() {
                al.unbind(ac).bind(ac, function (aL, aM, aK, aI) {
                    var aJ = aa,
                        s = I;
                    Q.scrollBy(aK * ay.mouseWheelSpeed, -aI * ay.mouseWheelSpeed, false);
                    return aJ == aa && s == I
                })
            }

            function n() {
                al.unbind(ac)
            }

            function aB() {
                return false
            }

            function J() {
                Y.find(":input,a").unbind("focus.jsp").bind("focus.jsp", function (s) {
                    ab(s.target, false)
                })
            }

            function E() {
                Y.find(":input,a").unbind("focus.jsp")
            }

            function S() {
                var s, aI, aK = [];
                aE && aK.push(am[0]);
                az && aK.push(U[0]);
                Y.focus(function () {
                    D.focus()
                });
                D.attr("tabindex", 0).unbind("keydown.jsp keypress.jsp").bind("keydown.jsp", function (aN) {
                    if (aN.target !== this && !(aK.length && b(aN.target).closest(aK).length)) {
                        return
                    }
                    var aM = aa,
                        aL = I;
                    switch (aN.keyCode) {
                    case 40:
                    case 38:
                    case 34:
                    case 32:
                    case 33:
                    case 39:
                    case 37:
                        s = aN.keyCode;
                        aJ();
                        break;
                    case 35:
                        M(Z - v);
                        s = null;
                        break;
                    case 36:
                        M(0);
                        s = null;
                        break
                    }
                    aI = aN.keyCode == s && aM != aa || aL != I;
                    return !aI
                }).bind("keypress.jsp", function (aL) {
                    if (aL.keyCode == s) {
                        aJ()
                    }
                    return !aI
                });
                if (ay.hideFocus) {
                    D.css("outline", "none");
                    if ("hideFocus" in al[0]) {
                        D.attr("hideFocus", true)
                    }
                } else {
                    D.css("outline", "");
                    if ("hideFocus" in al[0]) {
                        D.attr("hideFocus", false)
                    }
                }

                function aJ() {
                    var aM = aa,
                        aL = I;
                    switch (s) {
                    case 40:
                        Q.scrollByY(ay.keyboardSpeed, false);
                        break;
                    case 38:
                        Q.scrollByY(-ay.keyboardSpeed, false);
                        break;
                    case 34:
                    case 32:
                        Q.scrollByY(v * ay.scrollPagePercent, false);
                        break;
                    case 33:
                        Q.scrollByY(-v * ay.scrollPagePercent, false);
                        break;
                    case 39:
                        Q.scrollByX(ay.keyboardSpeed, false);
                        break;
                    case 37:
                        Q.scrollByX(-ay.keyboardSpeed, false);
                        break
                    }
                    aI = aM != aa || aL != I;
                    return aI
                }
            }

            function R() {
                D.attr("tabindex", "-1").removeAttr("tabindex").unbind("keydown.jsp keypress.jsp")
            }

            function C() {
                if (location.hash && location.hash.length > 1) {
                    var aK, aI, aJ = escape(location.hash.substr(1));
                    try {
                        aK = b("#" + aJ + ', a[name="' + aJ + '"]')
                    } catch (s) {
                        return
                    }
                    if (aK.length && Y.find(aJ)) {
                        if (al.scrollTop() === 0) {
                            aI = setInterval(function () {
                                if (al.scrollTop() > 0) {
                                    ab(aK, true);
                                    b(document).scrollTop(al.position().top);
                                    clearInterval(aI)
                                }
                            }, 50)
                        } else {
                            ab(aK, true);
                            b(document).scrollTop(al.position().top)
                        }
                    }
                }
            }

            function m() {
                if (b(document.body).data("jspHijack")) {
                    return
                }
                b(document.body).data("jspHijack", true);
                b(document.body).delegate("a[href*=#]", "click", function (s) {
                    var aI = this.href.substr(0, this.href.indexOf("#")),
                        aK = location.href,
                        aO, aP, aJ, aM, aL, aN;
                    if (location.href.indexOf("#") !== -1) {
                        aK = location.href.substr(0, location.href.indexOf("#"))
                    }
                    if (aI !== aK) {
                        return
                    }
                    aO = escape(this.href.substr(this.href.indexOf("#") + 1));
                    aP;
                    try {
                        aP = b("#" + aO + ', a[name="' + aO + '"]')
                    } catch (aQ) {
                        return
                    }
                    if (!aP.length) {
                        return
                    }
                    aJ = aP.closest(".jspScrollable");
                    aM = aJ.data("jsp");
                    aM.scrollToElement(aP, true);
                    if (aJ[0].scrollIntoView) {
                        aL = b(a).scrollTop();
                        aN = aP.offset().top;
                        if (aN < aL || aN > aL + b(a).height()) {
                            aJ[0].scrollIntoView()
                        }
                    }
                    s.preventDefault()
                })
            }

            function an() {
                var aJ, aI, aL, aK, aM, s = false;
                al.unbind("touchstart.jsp touchmove.jsp touchend.jsp click.jsp-touchclick").bind("touchstart.jsp", function (aN) {
                    var aO = aN.originalEvent.touches[0];
                    aJ = aC();
                    aI = aA();
                    aL = aO.pageX;
                    aK = aO.pageY;
                    aM = false;
                    s = true
                }).bind("touchmove.jsp", function (aQ) {
                    if (!s) {
                        return
                    }
                    var aP = aQ.originalEvent.touches[0],
                        aO = aa,
                        aN = I;
                    Q.scrollTo(aJ + aL - aP.pageX, aI + aK - aP.pageY);
                    aM = aM || Math.abs(aL - aP.pageX) > 5 || Math.abs(aK - aP.pageY) > 5;
                    return aO == aa && aN == I
                }).bind("touchend.jsp", function (aN) {
                    s = false
                }).bind("click.jsp-touchclick", function (aN) {
                    if (aM) {
                        aM = false;
                        return false
                    }
                })
            }

            function g() {
                var s = aA(),
                    aI = aC();
                D.removeClass("jspScrollable").unbind(".jsp");
                D.replaceWith(ao.append(Y.children()));
                ao.scrollTop(s);
                ao.scrollLeft(aI);
                if (av) {
                    clearInterval(av)
                }
            }
            b.extend(Q, {
                reinitialise: function (aI) {
                    aI = b.extend({}, ay, aI);
                    ar(aI)
                },
                scrollToElement: function (aJ, aI, s) {
                    ab(aJ, aI, s)
                },
                scrollTo: function (aJ, s, aI) {
                    N(aJ, aI);
                    M(s, aI)
                },
                scrollToX: function (aI, s) {
                    N(aI, s)
                },
                scrollToY: function (s, aI) {
                    M(s, aI)
                },
                scrollToPercentX: function (aI, s) {
                    N(aI * (T - aj), s)
                },
                scrollToPercentY: function (aI, s) {
                    M(aI * (Z - v), s)
                },
                scrollBy: function (aI, s, aJ) {
                    Q.scrollByX(aI, aJ);
                    Q.scrollByY(s, aJ)
                },
                scrollByX: function (s, aJ) {
                    var aI = aC() + Math[s < 0 ? "floor" : "ceil"](s),
                        aK = aI / (T - aj);
                    W(aK * j, aJ)
                },
                scrollByY: function (s, aJ) {
                    var aI = aA() + Math[s < 0 ? "floor" : "ceil"](s),
                        aK = aI / (Z - v);
                    V(aK * i, aJ)
                },
                positionDragX: function (s, aI) {
                    W(s, aI)
                },
                positionDragY: function (aI, s) {
                    V(aI, s)
                },
                animate: function (aI, aL, s, aK) {
                    var aJ = {};
                    aJ[aL] = s;
                    aI.animate(aJ, {
                        duration: ay.animateDuration,
                        easing: ay.animateEase,
                        queue: false,
                        step: aK
                    })
                },
                getContentPositionX: function () {
                    return aC()
                },
                getContentPositionY: function () {
                    return aA()
                },
                getContentWidth: function () {
                    return T
                },
                getContentHeight: function () {
                    return Z
                },
                getPercentScrolledX: function () {
                    return aC() / (T - aj)
                },
                getPercentScrolledY: function () {
                    return aA() / (Z - v)
                },
                getIsScrollableH: function () {
                    return aE
                },
                getIsScrollableV: function () {
                    return az
                },
                getContentPane: function () {
                    return Y
                },
                scrollToBottom: function (s) {
                    V(i, s)
                },
                hijackInternalLinks: b.noop,
                destroy: function () {
                    g()
                }
            });
            ar(O)
        }
        e = b.extend({}, b.fn.jScrollPane.defaults, e);
        b.each(["mouseWheelSpeed", "arrowButtonSpeed", "trackClickSpeed", "keyboardSpeed"], function () {
            e[this] = e[this] || e.speed
        });
        return this.each(function () {
            var f = b(this),
                g = f.data("jsp");
            if (g) {
                g.reinitialise(e)
            } else {
                b("script", f).filter('[type="text/javascript"],:not([type])').remove();
                g = new d(f, e);
                f.data("jsp", g)
            }
        })
    };
    b.fn.jScrollPane.defaults = {
        showArrows: false,
        maintainPosition: true,
        stickToBottom: false,
        stickToRight: false,
        clickOnTrack: true,
        autoReinitialise: false,
        autoReinitialiseDelay: 500,
        verticalDragMinHeight: 0,
        verticalDragMaxHeight: 99999,
        horizontalDragMinWidth: 0,
        horizontalDragMaxWidth: 99999,
        contentWidth: c,
        animateScroll: false,
        animateDuration: 300,
        animateEase: "linear",
        hijackInternalLinks: false,
        verticalGutter: 4,
        horizontalGutter: 4,
        mouseWheelSpeed: 0,
        arrowButtonSpeed: 0,
        arrowRepeatFreq: 50,
        arrowScrollOnHover: false,
        trackClickSpeed: 0,
        trackClickRepeatFreq: 70,
        verticalArrowPositions: "split",
        horizontalArrowPositions: "split",
        enableKeyboardNavigation: true,
        hideFocus: false,
        keyboardSpeed: 0,
        initialDelay: 300,
        speed: 30,
        scrollPagePercent: 0.8
    }
})(jQuery, this);
(function ($) {
    var isTouchDevice = function () {
        try {
            return "ontouchstart" in document.documentElement
        } catch (e) {
            return false
        }
    }();
    $.fn.doubletap = function (onDoubleTapCallback, onTapCallback, delay) {
        var eventName, action;
        delay = delay == null ? 500 : delay;
        eventName = isTouchDevice == true ? "touchend" : "click";
        $(this).bind(eventName, function (event) {
            event.preventDefault();
            var now = (new Date).getTime();
            var lastTouch = $(this).data("lastTouch") || now + 1;
            var delta = now - lastTouch;
            clearTimeout(action);
            if (delta < delay && delta > 0) {
                if (onDoubleTapCallback !=
                    null && typeof onDoubleTapCallback == "function") onDoubleTapCallback(event)
            } else {
                $(this).data("lastTouch", now);
                action = setTimeout(function (evt) {
                    if (onTapCallback != null && typeof onTapCallback == "function") onTapCallback(evt);
                    clearTimeout(action)
                }, delay, [event])
            }
            $(this).data("lastTouch", now)
        })
    }
})(jQuery);
(function ($) {
    $.fn.touchwipe = function (settings) {
        var config = {
            min_move_x: 20,
            min_move_y: 20,
            wipeLeft: function () {},
            wipeRight: function () {},
            wipeUp: function () {},
            wipeDown: function () {},
            preventDefaultEvents: true
        };
        if (settings) $.extend(config, settings);
        var _this = this;
        this.config = config;
        this.each(function () {
            var startX;
            var startY;
            var isMoving = false;

            function cancelTouch() {
                this.removeEventListener("touchmove", onTouchMove);
                startX = null;
                isMoving = false
            }

            function onTouchMove(e) {
                if (e.touches.length > 1) isMoving = false;
                if (_this.config.preventDefaultEvents) e.preventDefault();
                if (isMoving && (jQuery(_this).data("pageMv") == null || (jQuery(_this).data("pageMv") && jQuery(_this).data('pageMv').length == 0))) {
                    var x = e.touches[0].pageX;
                    var y = e.touches[0].pageY;
                    var dx = startX - x;
                    var dy = startY - y;
                    if (Math.abs(dx) >= config.min_move_x) {
                        cancelTouch();
                        if (dx > 0) config.wipeLeft();
                        else config.wipeRight()
                    } else if (Math.abs(dy) >= config.min_move_y) {
                        cancelTouch();
                        if (dy > 0) config.wipeDown();
                        else config.wipeUp()
                    }
                }
            }

            function onTouchStart(e) {
                if (e.touches.length == 1) {
                    startX = e.touches[0].pageX;
                    startY = e.touches[0].pageY;
                    isMoving = true;
                    this.addEventListener("touchmove", onTouchMove, false)
                }
            }
            if ("ontouchstart" in document.documentElement) this.addEventListener("touchstart", onTouchStart, false)
        });
        return this
    }
})(jQuery);
(function (h) {
    var A, s = "",
        K = Math.PI,
        I = K / 2,
        z = "ontouchstart" in document.documentElement,
        M = {
            backward: ["tl", "bl"],
            forward: ["tr", "br"],
            all: ["tl", "bl", "tr", "br"]
        }, T = ["single", "double"],
        U = {
            page: 1,
            gradients: !0,
            duration: 600,
            acceleration: !0,
            display: "double",
            cornerDragging: !0,
            when: null
        }, L = z ? {
            start: "touchstart",
            move: "touchmove",
            end: "touchend"
        } : {
            start: "mousedown",
            move: "mousemove",
            end: "mouseup"
        }, V = {
            folding: null,
            corners: "forward",
            cornerSize: 100,
            gradients: !0,
            duration: 600,
            acceleration: !0
        }, O = {
            0: {
                top: 0,
                left: 0,
                right: "auto",
                bottom: "auto"
            },
            1: {
                top: 0,
                right: 0,
                left: "auto",
                bottom: "auto"
            }
        }, m = function (a, b, c, d) {
            return {
                css: {
                    position: "absolute",
                    top: a,
                    left: b,
                    overflow: d || "hidden",
                    "z-index": c || "auto"
                }
            }
        }, P = function (a, b, c, d, e) {
            var f = 1 - e,
                G = f * f * f,
                D = e * e * e;
            return l(Math.round(G * a.x + 3 * e * f * f * b.x + 3 * e * e * f * c.x + D * d.x), Math.round(G * a.y + 3 * e * f * f * b.y + 3 * e * e * f * c.y + D * d.y))
        }, l = function (a, b) {
            return {
                x: a,
                y: b
            }
        }, u = function (a, b, c) {
            return A && c ? " translate3d(" + a + "px," + b + "px, 0px) " : " translate(" + a + "px, " + b + "px) "
        }, v = function (a) {
            return " rotate(" + a + "deg) "
        }, q =
            function (a, b) {
                return Object.prototype.hasOwnProperty.call(b, a)
        }, W = function () {
            for (var a = ["Moz", "Webkit", "Khtml", "O", "ms"], b = a.length, c = ""; b--;) a[b] + "Transform" in document.body.style && (c = "-" + a[b].toLowerCase() + "-");
            return c
        }, Q = function (a, b, c, d, e) {
            var f, G = [];
            if ("-webkit-" == s) {
                for (f = 0; f < e; f++) G.push("color-stop(" + d[f][0] + ", " + d[f][1] + ")");
                a.css({
                    "background-image": "-webkit-gradient(linear, " + b.x + "% " + b.y + "%,  " + c.x + "% " + c.y + "%, " + G.join(",") + " )"
                })
            } else {
                b = {
                    x: b.x / 100 * a.width(),
                    y: b.y / 100 * a.height()
                };
                c = {
                    x: c.x / 100 * a.width(),
                    y: c.y / 100 * a.height()
                };
                var D = c.x - b.x;
                f = c.y - b.y;
                var h = Math.atan2(f, D),
                    k = h - Math.PI / 2,
                    k = Math.abs(a.width() * Math.sin(k)) + Math.abs(a.height() * Math.cos(k)),
                    D = Math.sqrt(f * f + D * D);
                c = l(c.x < b.x ? a.width() : 0, c.y < b.y ? a.height() : 0);
                var g = Math.tan(h);
                f = -1 / g;
                g = (f * c.x - c.y - g * b.x + b.y) / (f - g);
                c = f * g - f * c.x + c.y;
                b = Math.sqrt(Math.pow(g - b.x, 2) + Math.pow(c - b.y, 2));
                for (f = 0; f < e; f++) G.push(" " + d[f][1] + " " + 100 * (b + D * d[f][0]) / k + "%");
                a.css({
                    "background-image": s + "linear-gradient(" + -h + "rad," + G.join(",") + ")"
                })
            }
        }, R = "ontouchstart" in
            window ? {
                down: "touchstart",
                move: "touchmove",
                up: "touchend",
                over: "touchstart",
                out: "touchend"
        } : {
            down: "mousedown",
            move: "mousemove",
            up: "mouseup",
            over: "mouseover",
            out: "mouseout"
        }, g = {
            init: function (a) {
                void 0 === A && (A = "WebKitCSSMatrix" in window || "MozPerspective" in document.body.style, s = W());
                var b, c = this.data(),
                    d = this.children();
                a = h.extend({
                    width: this.width(),
                    height: this.height()
                }, U, a);
                c.opts = a;
                c.pageObjs = {};
                c.pages = {};
                c.pageWrap = {};
                c.pagePlace = {};
                c.pageMv = [];
                c.totalPages = a.pages || 0;
                if (a.when)
                    for (b in a.when) q(b,
                        a.when) && this.bind(b, a.when[b]);
                this.css({
                    position: "relative",
                    width: a.width,
                    height: a.height
                });
                this.turn("display", a.display);
                A && (!z && a.acceleration) && this.transform(u(0, 0, !0));
                for (b = 0; b < d.length; b++) this.turn("addPage", d[b], b + 1);
                this.turn("page", a.page);
                M = h.extend({}, M, a.corners);
                c.eventHandlers = {
                    move: function (a) {
                        for (var b in c.pages) q(b, c.pages) && k._eventMove.call(c.pages[b], a)
                    },
                    end: function (a) {
                        for (var b in c.pages) q(b, c.pages) && k._eventEnd.call(c.pages[b], a)
                    },
                    start: function (a) {
                        for (var b in c.pages)
                            if (q(b,
                                c.pages) && !1 === k._eventStart.call(c.pages[b], a)) return !1
                    }
                };
                h(this).bind(L.start, c.eventHandlers.start);
                a.cornerDragging ? h(document).bind(L.move, c.eventHandlers.move).bind(L.end, c.eventHandlers.end) : h(document).bind(L.end, c.eventHandlers.end);
                c.done = !0;
                return this
            },
            addPage: function (a, b) {
                var c = !1,
                    d = this.data(),
                    e = d.totalPages + 1;
                if (b)
                    if (b == e) b = e, c = !0;
                    else {
                        if (b > e) throw Error('It is impossible to add the page "' + b + '", the maximum value is: "' + e + '"');
                    } else b = e, c = !0;
                1 <= b && b <= e && (d.done && this.turn("stop"),
                    b in d.pageObjs && g._movePages.call(this, b, 1), c && (d.totalPages = e), d.pageObjs[b] = h(a).addClass("turn-page p" + b), g._addPage.call(this, b), d.done && this.turn("update"), g._removeFromDOM.call(this));
                return this
            },
            _addPage: function (a) {
                var b = this.data(),
                    c = b.pageObjs[a];
                if (c)
                    if (g._necessPage.call(this, a)) {
                        if (!b.pageWrap[a]) {
                            var d = "double" == b.display ? this.width() / 2 : this.width(),
                                e = this.height();
                            c.css({
                                width: d,
                                height: e
                            });
                            b.pagePlace[a] = a;
                            b.pageWrap[a] = h("<div/>", {
                                id: "turn-page-wrapper-" + a,
                                "class": "turn-page-wrapper",
                                page: a,
                                css: {
                                    position: "absolute",
                                    overflow: "hidden",
                                    width: d,
                                    height: e
                                }
                            }).css(O["double" == b.display ? a % 2 : 0]);
                            this.append(b.pageWrap[a]);
                            b.pageObjs[a].appendTo(b.pageWrap[a])
                        }(!a || 1 == g._setPageLoc.call(this, a)) && g._makeFlip.call(this, a)
                    } else b.pagePlace[a] = 0, b.pageObjs[a] && b.pageObjs[a].detach()
            },
            hasPage: function (a) {
                return a in this.data().pageObjs
            },
            destroy: function () {
                var a = this,
                    b = this.data();
                b.destroying = !0;
                jQuery.each("end first flip last pressed released start turning turned zooming missing".split(" "),
                    function (b, c) {
                        a.unbind(c)
                    });
                this.parent().unbind();
                var c = b.totalPages;
                if (b.eventHandlers)
                    for (jQuery(document).unbind(R.move, b.eventHandlers.move).unbind(R.up, b.eventHandlers.end); 0 !== c;) this.turn("removePage", c), c -= 1;
                b.fparent && b.fparent.remove();
                b.shadow && b.shadow.remove();
                this.removeData();
                b = null;
                this.trigger("destroyed");
                return this
            },
            _makeFlip: function (a) {
                var b = this.data();
                if (!b.pages[a] && b.pagePlace[a] == a) {
                    var c = "single" == b.display,
                        d = a % 2;
                    b.pages[a] = b.pageObjs[a].css({
                        width: c ? this.width() : this.width() /
                            2,
                        height: this.height()
                    }).flip({
                        page: a,
                        next: c && a === b.totalPages ? a - 1 : d || c ? a + 1 : a - 1,
                        turn: this,
                        duration: b.opts.duration,
                        acceleration: b.opts.acceleration,
                        corners: c ? "all" : d ? "forward" : "backward",
                        backGradient: b.opts.gradients,
                        frontGradient: b.opts.gradients,
                        cornerDragging: b.opts.cornerDragging
                    }).flip("disable", b.disabled).bind("pressed", g._pressed).bind("released", g._released).bind("start", g._start).bind("end", g._end).bind("flip", g._flip)
                }
                return b.pages[a]
            },
            _makeRange: function (a) {
                var b;
                this.data();
                var c = this.turn("range");
                if (c)
                    for (b = c[0]; b <= c[1]; b++) g._addPage.call(this, b);
                a && a()
            },
            range: function (a) {
                var b, c, d = this.data();
                a = a || d.tpage || d.page;
                var e = g._view.call(this, a);
                if (!(1 > a || a > d.totalPages)) return e[1] = e[1] || e[0], 1 <= e[0] && e[1] <= d.totalPages ? (a = Math.floor(9), d.totalPages - e[1] > e[0] ? (b = Math.min(e[0] - 1, a), c = 2 * a - b) : (c = Math.min(d.totalPages - e[1], a), b = 2 * a - c)) : c = b = 19, [Math.max(1, e[0] - b), Math.min(d.totalPages, e[1] + c)]
            },
            _necessPage: function (a) {
                if (0 === a) return !0;
                var b = this.turn("range");
                return a >= b[0] && a <= b[1]
            },
            _removeFromDOM: function () {
                var a,
                    b = this.data();
                for (a in b.pageWrap) q(a, b.pageWrap) && !g._necessPage.call(this, a) && g._removePageFromDOM.call(this, a)
            },
            _removePageFromDOM: function (a) {
                var b = this.data();
                if (b.pages[a]) {
                    var c = b.pages[a].data();
                    c.f && c.f.fwrapper && c.f.fwrapper.detach();
                    b.pages[a].detach();
                    delete b.pages[a]
                }
                b.pageObjs[a] && b.pageObjs[a].detach();
                b.pageWrap[a] && (b.pageWrap[a].detach(), delete b.pageWrap[a]);
                delete b.pagePlace[a]
            },
            removePage: function (a) {
                var b = this.data();
                b.pageObjs[a] && (this.turn("stop"), g._removePageFromDOM.call(this,
                    a), delete b.pageObjs[a], g._movePages.call(this, a, -1), b.totalPages -= 1, 0 < b.totalPages && g._makeRange.call(this), b.page > b.totalPages && this.turn("page", b.totalPages));
                return this
            },
            _movePages: function (a, b) {
                var c, d = this.data(),
                    e = "single" == d.display,
                    f = function (a) {
                        var c = a + b,
                            f = c % 2;
                        d.pageObjs[a] && (d.pageObjs[c] = d.pageObjs[a].removeClass5("page" + a).addClass5("page" + c));
                        d.pagePlace[a] && d.pageWrap[a] && (d.pagePlace[c] = c, d.pageWrap[c] = d.pageWrap[a].css(O[e ? 0 : f]).attr("page", c), d.pages[a] && (d.pages[c] = d.pages[a].flip("options", {
                            page: c,
                            next: e || f ? c + 1 : c - 1,
                            corners: e ? "all" : f ? "forward" : "backward"
                        })), b && (delete d.pages[a], delete d.pagePlace[a], delete d.pageObjs[a], delete d.pageWrap[a], delete d.pageObjs[a]))
                    };
                if (0 < b)
                    for (c = d.totalPages; c >= a; c--) f(c);
                else
                    for (c = a; c <= d.totalPages; c++) f(c)
            },
            display: function (a) {
                var b = this.data(),
                    c = b.display;
                if (a) {
                    if (-1 == h.inArray(a, T)) throw Error('"' + a + '" is not a value for display');
                    "single" == a ? b.pageObjs[0] || (this.turn("stop").css({
                        overflow: "hidden"
                    }), b.pageObjs[0] = h("<div />", {
                        "class": "turn-page p-temporal"
                    }).css({
                        width: this.width(),
                        height: this.height(),
                        "background-color": "#ffffff"
                    }).appendTo(this)) : b.pageObjs[0] && (this.turn("stop").css({
                        overflow: ""
                    }), b.pageObjs[0].detach());
                    b.display = a;
                    c && (a = this.turn("size"), g._movePages.call(this, 1, 0), this.turn("size", a.width, a.height).turn("update"));
                    return this
                }
                return c
            },
            animating: function () {
                return 0 < this.data().pageMv.length
            },
            cornerActivated: function () {
                var a, b = this.data();
                for (a in b.pages)
                    if (q(a, b.pages) && b.pages[a].data().f.hoveringCorner) return !0;
                return !1
            },
            disable: function (a) {
                var b, c =
                        this.data(),
                    d = this.turn("view");
                c.disabled = void 0 === a || !0 === a;
                for (b in c.pages) q(b, c.pages) && c.pages[b].flip("disable", a ? h.inArray(b, d) : !1);
                return this
            },
            setCornerDragging: function (a) {
                var b, c = this.data();
                this.turn("view");
                c.opts.cornerDragging = a;
                for (b in c.pages) q(b, c.pages) && (c.pages[b].data().f.opts.cornerDragging = a)
            },
            size: function (a, b, c) {
                if (a && b) {
                    this.turn("stop");
                    var d = this.data(),
                        e = "double" == d.display ? a / 2 : a,
                        f;
                    if (c)
                        for (f in this.css({
                            width: a,
                            height: b
                        }), d.pageObjs[0] && d.pageObjs[0].css({
                            width: e,
                            height: b
                        }), d.pageWrap) q(f, d.pageWrap) && (d.pageWrap[f].css({
                            width: e,
                            height: b
                        }), d.pageObjs[f].width(), d.pageObjs[f].animate({
                            width: e,
                            height: b
                        }, {
                            duration: 700,
                            step: function (a, b) {}
                        }), d.pages[f] && d.pages[f].css({
                            width: e,
                            height: b
                        }));
                    else
                        for (f in this.css({
                            width: a,
                            height: b
                        }), d.pageObjs[0] && d.pageObjs[0].css({
                            width: e,
                            height: b
                        }), d.pageWrap) q(f, d.pageWrap) && (d.pageObjs[f].css({
                            width: e,
                            height: b
                        }), d.pageWrap[f].css({
                            width: e,
                            height: b
                        }), d.pages[f] && d.pages[f].css({
                            width: e,
                            height: b
                        }));
                    this.turn("resize");
                    return this
                }
                return {
                    width: this.width(),
                    height: this.height()
                }
            },
            resize: function () {
                var a, b = this.data();
                b.pages[0] && (b.pageWrap[0].css({
                    left: -this.width()
                }), b.pages[0].flip("resize", !0));
                for (a = 1; a <= b.totalPages; a++) b.pages[a] && b.pages[a].flip("resize", !0);
                g._updateShadow.call(this)
            },
            _removeMv: function (a) {
                var b, c = this.data();
                for (b = 0; b < c.pageMv.length; b++)
                    if (c.pageMv[b] == a) return c.pageMv.splice(b, 1), !0;
                return !1
            },
            _addMv: function (a) {
                var b = this.data();
                g._removeMv.call(this, a);
                b.pageMv.push(a)
            },
            _view: function (a) {
                var b = this.data();
                a = a || b.page;
                return "double" ==
                    b.display ? a % 2 ? [a - 1, a] : [a, a + 1] : [a]
            },
            view: function (a) {
                var b = this.data();
                a = g._view.call(this, a);
                return "double" == b.display ? [0 < a[0] ? a[0] : 0, a[1] <= b.totalPages ? a[1] : 0] : [0 < a[0] && a[0] <= b.totalPages ? a[0] : 0]
            },
            stop: function (a) {
                var b, c = this.data(),
                    d = c.pageMv;
                c.pageMv = [];
                c.tpage && (c.page = c.tpage, delete c.tpage);
                for (b in d) q(b, d) && (k._moveFoldingPage.call(c.pages[d[b]], null), k.hideFoldedPage.call(c.pages[d[b]], !1), a = c.pages[d[b]].data().f.opts, c.pagePlace[a.next] = a.next, a.force && (a.next = 0 === a.page % 2 ? a.page - 1 : a.page +
                    1, delete a.force));
                this.turn("update");
                return this
            },
            pages: function (a) {
                var b = this.data();
                if (a) {
                    if (a < b.totalPages) {
                        for (var c = a + 1; c <= b.totalPages; c++) this.turn("removePage", c);
                        this.turn("page") > a && this.turn("page", a)
                    }
                    b.totalPages = a;
                    return this
                }
                return b.totalPages
            },
            _fitPage: function (a, b) {
                var c = this.data(),
                    d = this.turn("view", a);
                c.page != a && (this.trigger("turning", [a, d]), -1 != h.inArray(1, d) && this.trigger("first"), -1 != h.inArray(c.totalPages, d) && this.trigger("last"));
                c.pageObjs[a] && (c.tpage = a, this.turn("stop",
                    b), g._removeFromDOM.call(this), g._makeRange.call(this), g._updateShadow.call(this), this.trigger("turned", [a, d]))
            },
            _missing: function (a) {
                var b = this.data(),
                    c = this.turn("range", a),
                    d = [];
                for (a = c[0]; a <= c[1]; a++) b.pageObjs[a] || d.push(a);
                0 < d.length && this.trigger("missing", [d])
            },
            _turnPage: function (a) {
                var b, c, d = this.data(),
                    e = this.turn("view"),
                    f = this.turn("view", a);
                d.page != a && (this.trigger("turning", [a, f]), -1 != h.inArray(1, f) && this.trigger("first"), -1 != h.inArray(d.totalPages, f) && this.trigger("last"));
                d.pageObjs[a] &&
                    (d.tpage = a, "single" == d.display ? (b = e[0], c = f[0]) : e[1] && a > e[1] ? (b = e[1], c = f[0]) : e[0] && a < e[0] && (b = e[0], c = f[1]), this.turn("stop"), g._makeRange.call(this), d.pages[b] && (a = d.pages[b].data().f.opts, d.tpage = c, a.next != c && (a.next = c, d.pagePlace[c] = a.page, a.force = !0), "single" == d.display ? d.pages[b].flip("turnPage", f[0] > e[0] ? "br" : "bl") : d.pages[b].flip("turnPage")))
            },
            page: function (a) {
                a = parseInt(a, 10);
                var b = this.data();
                return 0 < a && a <= b.totalPages ? (!b.done || -1 != h.inArray(a, this.turn("view")) ? g._fitPage.call(this, a) :
                    g._turnPage.call(this, a), this) : b.page
            },
            next: function () {
                var a = this.data();
                return this.turn("page", g._view.call(this, a.page).pop() + 1)
            },
            previous: function () {
                var a = this.data();
                return this.turn("page", g._view.call(this, a.page).shift() - 1)
            },
            _addMotionPage: function () {
                var a = h(this).data().f.opts,
                    b = a.turn,
                    c = b.data();
                a.pageMv = a.page;
                g._addMv.call(b, a.pageMv);
                c.pagePlace[a.next] = a.page;
                b.turn("update")
            },
            _start: function (a, b, c) {
                var d = b.turn.data(),
                    e = h.Event("start");
                a.stopPropagation();
                b.turn.trigger(e, [b, c]);
                e.isDefaultPrevented() ?
                    a.preventDefault() : ("single" == d.display && (c = "l" == c.charAt(1), 1 == b.page && c || b.page == d.totalPages && !c ? a.preventDefault() : c ? (b.next = b.next < b.page ? b.next : b.page - 1, b.force = !0) : b.next = b.next > b.page ? b.next : b.page + 1), g._addMotionPage.call(this), (1 == b.next || b.next == d.totalPages && 0 == d.totalPages % 2) && g._updateShadow.call(b.turn))
            },
            _end: function (a, b) {
                var c = h(this).data().f.opts,
                    d = c.turn,
                    e = d.data();
                a.stopPropagation();
                if (b || e.tpage) {
                    if (e.tpage == c.next || e.tpage == c.page) delete e.tpage, g._fitPage.call(d, e.tpage ||
                        c.next, !0)
                } else z && g._removeMv.call(d, c.pageMv), d.turn("update")
            },
            _pressed: function () {
                var a = h(this).data().f;
                a.opts.turn.data();
                return a.time = (new Date).getTime()
            },
            _released: function (a, b) {
                var c = h(this),
                    d = c.data().f;
                a.stopPropagation();
                200 > (new Date).getTime() - d.time || 0 > b.x || b.x > h(this).width() ? (a.preventDefault(), d.opts.turn.data().tpage = d.opts.next, d.opts.turn.turn("update"), h(c).flip("turnPage")) : jQuery(this).removeClass5("flexpaper_page_zoomIn").removeClass5("flexpaper_page_zoomOut").addClass5("flexpaper_page_dragPage")
            },
            _flip: function () {
                var a = h(this).data().f.opts;
                a.turn.trigger("turn", [a.next])
            },
            calculateZ: function (a) {
                var b, c, d, e, f = this,
                    h = this.data();
                b = this.turn("view");
                var k = b[0] || b[1],
                    g = {
                        pageZ: {},
                        partZ: {},
                        pageV: {}
                    }, l = function (a) {
                        a = f.turn("view", a);
                        a[0] && (g.pageV[a[0]] = !0);
                        a[1] && (g.pageV[a[1]] = !0)
                    };
                for (b = 0; b < a.length; b++) c = a[b], d = h.pages[c].data().f.opts.next, e = h.pagePlace[c], l(c), l(d), c = h.pagePlace[d] == d ? d : c, g.pageZ[c] = h.totalPages - Math.abs(k - c), g.partZ[e] = 2 * h.totalPages + Math.abs(k - c);
                return g
            },
            update: function () {
                var a,
                    b = this.data();
                if (b.pageMv.length && 0 !== b.pageMv[0]) {
                    var c = this.turn("calculateZ", b.pageMv);
                    this.turn("view", b.tpage);
                    for (a in b.pageWrap) q(a, b.pageWrap) && (b.pageWrap[a].css({
                        display: c.pageV[a] ? "" : "none",
                        "z-index": c.pageZ[a] || 0
                    }), b.pages[a] && (b.pages[a].flip("z", c.partZ[a] || null), c.pageV[a] && b.pages[a].flip("resize"), b.tpage && b.pages[a].flip("disable", !0)))
                } else
                    for (a in b.pageWrap) q(a, b.pageWrap) && (c = g._setPageLoc.call(this, a), b.pages[a] && b.pages[a].flip("disable", b.disabled || 1 != c).flip("z", null))
            },
            _updateShadow: function () {
                var a = this.data(),
                    b = this.turn("view"),
                    c = this.width(),
                    d = this.height(),
                    e = "single" == a.display ? c : c / 2;
                a.shadow || (a.shadow = h("<div />", {
                    "class": "flexpaper_shadow",
                    css: m(0, 0, 0).css
                }).appendTo(this));
                b[0] == a.totalPages && 0 == a.totalPages % 2 ? a.shadow.css({
                    width: e,
                    height: d,
                    top: 0,
                    left: 0
                }) : 0 == b[0] ? a.shadow.css({
                    width: e,
                    height: d,
                    top: 0,
                    left: e
                }) : a.shadow.css({
                    width: c,
                    height: d,
                    top: 0,
                    left: 0
                })
            },
            _setPageLoc: function (a) {
                var b = this.data(),
                    c = this.turn("view");
                if (a == c[0] || a == c[1]) return b.pageWrap[a].css({
                    "z-index": b.totalPages,
                    display: ""
                }), 1;
                if ("single" == b.display && a == c[0] + 1 || "double" == b.display && a == c[0] - 2 || a == c[1] + 2) return b.pageWrap[a].css({
                    "z-index": b.totalPages - 1,
                    display: ""
                }), 2;
                b.pageWrap[a].css({
                    "z-index": 0,
                    display: "none"
                });
                return 0
            }
        }, k = {
            init: function (a) {
                a.gradients && (a.frontGradient = !0, a.backGradient = !0);
                this.data({
                    f: {}
                });
                this.flip("options", a);
                k._addPageWrapper.call(this);
                return this
            },
            setData: function (a) {
                var b = this.data();
                b.f = h.extend(b.f, a);
                return this
            },
            options: function (a) {
                var b = this.data().f;
                return a ? (k.setData.call(this, {
                    opts: h.extend({}, b.opts || V, a)
                }), this) : b.opts
            },
            z: function (a) {
                var b = this.data().f;
                b.opts["z-index"] = a;
                b.fwrapper.css({
                    "z-index": a || parseInt(b.parent.css("z-index"), 10) || 0
                });
                return this
            },
            _cAllowed: function () {
                return M[this.data().f.opts.corners] || this.data().f.opts.corners
            },
            _cornerActivated: function (a) {
                if (void 0 === a.originalEvent) return !1;
                a = z ? a.originalEvent.touches : [a];
                var b = this.data().f,
                    c = b.parent.offset(),
                    d = this.width(),
                    e = this.height();
                a = {
                    x: Math.max(0, a[0].pageX - c.left),
                    y: Math.max(0, a[0].pageY - c.top)
                };
                b = b.opts.cornerSize;
                c = k._cAllowed.call(this);
                if (0 >= a.x || 0 >= a.y || a.x >= d || a.y >= e) return !1;
                if (a.y < b) a.corner = "t";
                else if (a.y >= e - b) a.corner = "b";
                else return !1; if (a.x <= b) a.corner += "l";
                else if (a.x >= d - b) a.corner += "r";
                else return !1;
                (d = -1 == h.inArray(a.corner, c) ? !1 : a) && this.trigger("cornerActivated");
                return d
            },
            _c: function (a, b) {
                var c = this.width(),
                    d = this.height();
                b = b || 0;
                return {
                    tl: l(b, b),
                    tr: l(c - b, b),
                    bl: l(b, d - b),
                    br: l(c - b, d - b)
                }[a]
            },
            _c2: function (a) {
                var b = this.width(),
                    c = this.height();
                return {
                    tl: l(2 * b, 0),
                    tr: l(-b, 0),
                    bl: l(2 * b, c),
                    br: l(-b, c)
                }[a]
            },
            _foldingPage: function (a) {
                a = this.data().f.opts;
                if (a.folding) return a.folding;
                if (a.turn) {
                    var b = a.turn.data();
                    return "single" == b.display ? b.pageObjs[a.next] ? b.pageObjs[0] : null : b.pageObjs[a.next]
                }
            },
            _backGradient: function () {
                var a = this.data().f,
                    b = a.opts.turn;
                if ((b = a.opts.backGradient && (!b || "single" == b.data().display || 2 != a.opts.page && a.opts.page != b.data().totalPages - 1)) && !a.bshadow) a.bshadow = h("<div/>", m(0, 0, 1)).css({
                    position: "",
                    width: this.width(),
                    height: this.height()
                }).appendTo(a.parent);
                return b
            },
            resize: function (a) {
                var b = this.data().f,
                    c = this.width(),
                    d = this.height(),
                    e = Math.round(Math.sqrt(Math.pow(c, 2) + Math.pow(d, 2)));
                a && (b.wrapper.css({
                    width: e,
                    height: e
                }), b.fwrapper.css({
                    width: e,
                    height: e
                }).children(":first-child").css({
                    width: c,
                    height: d
                }), b.fpage.css({
                    width: d,
                    height: c
                }), b.opts.frontGradient && b.ashadow.css({
                    width: d,
                    height: c
                }), k._backGradient.call(this) && b.bshadow.css({
                    width: c,
                    height: d
                }));
                b.parent.is(":visible") && (b.fwrapper.css({
                        top: b.parent.offset().top,
                        left: b.parent.offset().left
                    }),
                    b.opts.turn && b.fparent.css({
                        top: -b.opts.turn.offset().top,
                        left: -b.opts.turn.offset().left
                    }));
                this.flip("z", b.opts["z-index"])
            },
            _addPageWrapper: function () {
                var a = this.data().f,
                    b = this.parent();
                if (!a.wrapper) {
                    this.css("left");
                    this.css("top");
                    var c = this.width(),
                        d = this.height();
                    Math.round(Math.sqrt(Math.pow(c, 2) + Math.pow(d, 2)));
                    a.parent = b;
                    a.fparent = a.opts.turn ? a.opts.turn.data().fparent : h("#turn-fwrappers");
                    a.fparent || (c = h("<div/>", {
                        css: {
                            "pointer-events": "none"
                        }
                    }).hide(), c.data().flips = 0, a.opts.turn ? (c.css(m(-a.opts.turn.offset().top, -a.opts.turn.offset().left, "auto", "visible").css).appendTo(a.opts.turn), a.opts.turn.data().fparent = c) : c.css(m(0, 0, "auto", "visible").css).attr("id", "turn-fwrappers").appendTo(h("body")), a.fparent = c);
                    this.css({
                        position: "absolute",
                        top: 0,
                        left: 0,
                        bottom: "auto",
                        right: "auto"
                    });
                    a.wrapper = h("<div/>", m(0, 0, this.css("z-index"))).appendTo(b).prepend(this);
                    a.fwrapper = h("<div/>", m(b.offset().top, b.offset().left)).hide().appendTo(a.fparent);
                    a.fpage = h("<div/>", {
                        css: {
                            cursor: "default"
                        }
                    }).appendTo(h("<div/>", m(0, 0, 0,
                        "visible")).appendTo(a.fwrapper));
                    b = a.opts && a.opts.turn && "single" != a.opts.turn.data().display ? 'style="position:absolute;z-index:10;-webkit-backface-visibility:hidden;"' : "";
                    a.opts.frontGradient && (a.ashadow = h("<div " + b + "/>", m(0, 0, 1)).appendTo(a.fpage));
                    k.setData.call(this, a);
                    k.resize.call(this, !0)
                }
            },
            _fold: function (a) {
                var b = this,
                    c = 0,
                    d = 0,
                    e, f, h, g, x, q, B = l(0, 0),
                    N = l(0, 0),
                    n = l(0, 0),
                    t = this.width(),
                    w = this.height(),
                    m = k._foldingPage.call(this);
                Math.tan(d);
                var r = this.data().f,
                    y = r.opts.acceleration,
                    z = r.wrapper.height(),
                    s = k._c.call(this, a.corner),
                    H = "t" == a.corner.substr(0, 1),
                    E = "l" == a.corner.substr(1, 1),
                    J = function () {
                        var p = l(s.x ? s.x - a.x : a.x, s.y ? s.y - a.y : a.y),
                            F = Math.atan2(p.y, p.x),
                            C;
                        d = I - F;
                        c = 180 * (d / K);
                        C = l(E ? t - p.x / 2 : a.x + p.x / 2, p.y / 2);
                        var m = d - Math.atan2(C.y, C.x),
                            m = Math.max(0, Math.sin(m) * Math.sqrt(Math.pow(C.x, 2) + Math.pow(C.y, 2)));
                        n = l(m * Math.sin(d), m * Math.cos(d));
                        if (d > I && (n.x += Math.abs(n.y * Math.tan(F)), n.y = 0, Math.round(n.x * Math.tan(K - d)) < w)) return a.y = Math.sqrt(Math.pow(w, 2) + 2 * C.x * p.x), H && (a.y = w - a.y), J();
                        d > I && (p = K - d, F = z - w /
                            Math.sin(p), B = l(Math.round(F * Math.cos(p)), Math.round(F * Math.sin(p))), E && (B.x = -B.x), H && (B.y = -B.y));
                        e = Math.round(n.y / Math.tan(d) + n.x);
                        p = t - e;
                        F = p * Math.cos(2 * d);
                        C = p * Math.sin(2 * d);
                        N = l(Math.round(E ? p - F : e + F), Math.round(H ? C : w - C));
                        x = p * Math.sin(d);
                        p = k._c2.call(b, a.corner);
                        p = Math.sqrt(Math.pow(p.x - a.x, 2) + Math.pow(p.y - a.y, 2));
                        q = p < t ? p / t : 1;
                        r.opts.frontGradient && (g = 100 < x ? (x - 100) / x : 0, f = l(100 * (x * Math.sin(I - d) / w), 100 * (x * Math.cos(I - d) / t)), H && (f.y = 100 - f.y), E && (f.x = 100 - f.x));
                        k._backGradient.call(b) && (h = l(100 * (x * Math.sin(d) /
                            t), 100 * (x * Math.cos(d) / w)), E || (h.x = 100 - h.x), H || (h.y = 100 - h.y));
                        n.x = Math.round(n.x);
                        n.y = Math.round(n.y);
                        return !0
                    }, A = function (a, c, e, n) {
                        var m = ["0", "auto"],
                            x = (t - z) * e[0] / 100,
                            s = (w - z) * e[1] / 100;
                        c = {
                            left: m[c[0]],
                            top: m[c[1]],
                            right: m[c[2]],
                            bottom: m[c[3]]
                        };
                        m = 90 != n && -90 != n ? E ? -1 : 1 : 0;
                        e = e[0] + "% " + e[1] + "%";
                        b.css(c).transform(v(n) + u(a.x + m, a.y, y), e);
                        r.fpage.parent().css(c);
                        r.fpage.css({
                            "-webkit-box-shadow": String.format("rgba(0, 0, 0, {0}) 0px 0px 20px", 0.25 < g ? g : 0.25),
                            "-moz-box-shadow": String.format("rgba(0, 0, 0, {0}) 0px 0px 20px",
                                0.25 < g ? g : 0.25),
                            "-ms-box-shadow": String.format("rgba(0, 0, 0, {0}) 0px 0px 20px", 0.25 < g ? g : 0.25),
                            "-o-box-shadow": String.format("rgba(0, 0, 0, {0}) 0px 0px 20px", 0.25 < g ? g : 0.25),
                            "box-shadow": String.format("rgba(0, 0, 0, {0}) 0px 0px 20px", 0.25 < g ? g : 0.25),
                            "-webkit-transition": "-webkit-box-shadow 2s",
                            "-moz-transition": "-moz-box-shadow 2s",
                            "-o-transition": "-webkit-box-shadow 2s",
                            "-ms-transition": "-ms-box-shadow 2s"
                        });
                        r.wrapper.transform(u(-a.x + x - m, -a.y + s, y) + v(-n), e);
                        r.fwrapper.transform(u(-a.x + B.x + x, -a.y +
                            B.y + s, y) + v(-n), e);
                        r.fpage.parent().transform(v(n) + u(a.x + N.x - B.x, a.y + N.y - B.y, y), e);
                        r.opts.frontGradient && Q(r.ashadow, l(E ? 100 : 0, H ? 100 : 0), l(f.x, f.y), [
                            [g, "rgba(0,0,0,0)"],
                            [0.8 * (1 - g) + g, "rgba(0,0,0," + 0.2 * q + ")"],
                            [1, "rgba(255,255,255," + 0.2 * q + ")"]
                        ], 3, d);
                        k._backGradient.call(b) && Q(r.bshadow, l(E ? 0 : 100, H ? 0 : 100), l(h.x, h.y), [
                            [0.8, "rgba(0,0,0,0)"],
                            [1, "rgba(0,0,0," + 0.3 * q + ")"],
                            [1, "rgba(0,0,0,0)"]
                        ], 3)
                    };
                switch (a.corner) {
                case "tl":
                    a.x = Math.max(a.x, 1);
                    J();
                    A(n, [1, 0, 0, 1], [100, 0], c);
                    r.fpage.transform(u(-w, -t, y) + v(90 - 2 * c),
                        "100% 100%");
                    m.transform(v(90) + u(0, -w, y), "0% 0%");
                    break;
                case "tr":
                    a.x = Math.min(a.x, t - 1);
                    J();
                    A(l(-n.x, n.y), [0, 0, 0, 1], [0, 0], -c);
                    r.fpage.transform(u(0, -t, y) + v(-90 + 2 * c), "0% 100%");
                    m.transform(v(270) + u(-t, 0, y), "0% 0%");
                    break;
                case "bl":
                    a.x = Math.max(a.x, 1);
                    J();
                    A(l(n.x, -n.y), [1, 1, 0, 0], [100, 100], -c);
                    r.fpage.transform(u(-w, 0, y) + v(-90 + 2 * c), "100% 0%");
                    m.transform(v(270) + u(-t, 0, y), "0% 0%");
                    break;
                case "br":
                    a.x = Math.min(a.x, t - 1), J(), A(l(-n.x, -n.y), [0, 1, 1, 0], [0, 100], c), r.fpage.transform(v(90 - 2 * c), "0% 0%"), m.transform(v(90) +
                        u(0, -w, y), "0% 0%")
                }
                r.point = a
            },
            _moveFoldingPage: function (a) {
                var b = this.data().f,
                    c = k._foldingPage.call(this);
                if (c)
                    if (a) {
                        if (!b.fpage.children()[b.ashadow ? "1" : "0"]) k.setData.call(this, {
                            backParent: c.parent()
                        }), b.fpage.prepend(c)
                    } else b.backParent && b.backParent.prepend(c)
            },
            _showFoldedPage: function (a, b) {
                var c = k._foldingPage.call(this),
                    d = this.data(),
                    e = d.f;
                if (!e.point || e.point.corner != a.corner) {
                    var f = h.Event("start");
                    this.trigger(f, [e.opts, a.corner]);
                    if (f.isDefaultPrevented()) return !1
                }
                this.removeClass5("flexpaper_page_zoomIn").removeClass5("flexpaper_page_zoomOut").addClass5("flexpaper_page_dragPage");
                if (c) {
                    if (b) {
                        var g = this,
                            c = e.point && e.point.corner == a.corner ? e.point : k._c.call(this, a.corner, 1);
                        this.animatef({
                            from: [c.x, c.y],
                            to: [a.x, a.y],
                            duration: 500,
                            frame: function (b) {
                                a.x = Math.round(b[0]);
                                a.y = Math.round(b[1]);
                                k._fold.call(g, a)
                            }
                        })
                    } else k._fold.call(this, a), d.effect && !d.effect.turning && this.animatef(!1);
                    "none" == e.fwrapper[0].style.display && (e.fparent.show().data().flips++, k._moveFoldingPage.call(this, !0), e.fwrapper.show(), e.bshadow && e.bshadow.show());
                    return !0
                }
                return !1
            },
            hide: function () {
                var a = this.data().f,
                    b = k._foldingPage.call(this);
                0 === --a.fparent.data().flips && a.fparent.hide();
                this.css({
                    left: 0,
                    top: 0,
                    right: "auto",
                    bottom: "auto"
                }).transform("");
                a.wrapper.transform("");
                a.fwrapper.hide();
                a.bshadow && a.bshadow.hide();
                b.transform("");
                return this
            },
            hideFoldedPage: function (a) {
                var b = this.data().f;
                this.removeClass5("flexpaper_page_dragPage").removeClass5("flexpaper_page_zoomOut").addClass5("flexpaper_page_zoomIn");
                if (b.point) {
                    b.hoveringCorner = !1;
                    var c = this,
                        d = b.point,
                        e = function () {
                            b.point = null;
                            c.flip("hide");
                            c.trigger("end", [!1])
                        };
                    if (a) {
                        var f = k._c.call(this, d.corner);
                        a = "t" == d.corner.substr(0, 1) ? Math.min(0, d.y - f.y) / 2 : Math.max(0, d.y - f.y) / 2;
                        var g = l(d.x, d.y + a),
                            h = l(f.x, f.y - a);
                        this.animatef({
                            from: 0,
                            to: 1,
                            frame: function (a) {
                                a = P(d, g, h, f, a);
                                d.x = a.x;
                                d.y = a.y;
                                k._fold.call(c, d)
                            },
                            complete: e,
                            duration: 800,
                            hiding: !0
                        })
                    } else this.animatef(!1), e()
                }
            },
            turnPage: function (a) {
                var b = this,
                    c = this.data().f;
                a = {
                    corner: c.corner ? c.corner.corner : a || k._cAllowed.call(this)[0]
                };
                var d = c.point || k._c.call(this, a.corner, c.opts.turn ? c.opts.turn.data().opts.elevation :
                    0),
                    e = k._c2.call(this, a.corner);
                this.trigger("flip").animatef({
                    from: 0,
                    to: 1,
                    frame: function (c) {
                        c = P(d, d, e, e, c);
                        a.x = c.x;
                        a.y = c.y;
                        k._showFoldedPage.call(b, a)
                    },
                    complete: function () {
                        b.trigger("end", [!0])
                    },
                    duration: c.opts.duration,
                    turning: !0
                });
                c.corner = null
            },
            moving: function () {
                return "effect" in this.data()
            },
            isTurning: function () {
                return this.flip("moving") && this.data().effect.turning
            },
            _eventStart: function (a) {
                var b = this.data().f;
                if (!b.disabled && !this.flip("isTurning")) {
                    b.corner = k._cornerActivated.call(this, a);
                    if (b.corner &&
                        k._foldingPage.call(this, b.corner)) return k._moveFoldingPage.call(this, !0), this.trigger("pressed", [b.point]), !1;
                    b.corner = null
                }
            },
            _eventMove: function (a) {
                var b = this.data().f;
                if (b && !b.disabled && b.opts.cornerDragging)
                    if (a = z ? a.originalEvent.touches : [a], b.corner && !this.flip("isTurning")) {
                        var c = b.parent.offset();
                        b.corner.x = a[0].pageX - c.left;
                        b.corner.y = a[0].pageY - c.top;
                        k._showFoldedPage.call(this, b.corner)
                    } else !this.data().effect && this.is(":visible") && ((a = k._cornerActivated.call(this, a[0])) && !this.flip("isTurning") ?
                    (c = k._c.call(this, a.corner, b.opts.cornerSize / 2), a.x = c.x, a.y = c.y, b.hoveringCorner = !0, k._showFoldedPage.call(this, a, !0)) : k.hideFoldedPage.call(this, !0))
            },
            _eventEnd: function () {
                var a = this.data().f;
                if (a && !a.disabled && a.point) {
                    var b = h.Event("released");
                    this.trigger(b, [a.point]);
                    b.isDefaultPrevented() || k.hideFoldedPage.call(this, !0)
                }
                a && (a.corner = null)
            },
            disable: function (a) {
                k.setData.call(this, {
                    disabled: a
                });
                return this
            }
        }, S = function (a, b, c) {
            if (!c[0] || "object" == typeof c[0]) return b.init.apply(a, c);
            if (b[c[0]] &&
                "_" != c[0].toString().substr(0, 1)) return b[c[0]].apply(a, Array.prototype.slice.call(c, 1));
            throw c[0] + " is an invalid value";
        };
    window.requestAnim = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function (a) {
        window.setTimeout(a, 1E3 / 60)
    };
    h.extend(h.fn, {
        flip: function (a, b) {
            return S(this, k, arguments)
        },
        turn: function (a) {
            return S(this, g, arguments)
        },
        transform: function (a, b) {
            var c = {};
            b && (c[s + "transform-origin"] =
                b);
            c[s + "transform"] = a;
            return this.css(c)
        },
        animatef: function (a) {
            var b = this.data();
            b.effect && b.effect.stop();
            if (a) {
                a.to.length || (a.to = [a.to]);
                a.from.length || (a.from = [a.from]);
                a.easing || (a.easing = function (a, b, c, d, e) {
                    return d * Math.sqrt(1 - (b = b / e - 1) * b) + c
                });
                var c, d = [],
                    e = a.to.length,
                    f = this,
                    g = a.fps || 30,
                    k = -g,
                    l = !0,
                    m = function () {
                        if (b.effect && l) {
                            var c, h = [];
                            k = Math.min(a.duration, k + g);
                            for (c = 0; c < e; c++) h.push(a.easing(1, k, a.from[c], d[c], a.duration));
                            a.frame(1 == e ? h[0] : h);
                            k == a.duration ? (delete b.effect, f.data(b), a.complete &&
                                a.complete()) : window.requestAnim(m)
                        }
                    };
                for (c = 0; c < e; c++) d.push(a.to[c] - a.from[c]);
                b.effect = h.extend({
                    stop: function () {
                        l = !1
                    },
                    easing: function (a, b, c, d, e) {
                        return d * Math.sqrt(1 - (b = b / e - 1) * b) + c
                    }
                }, a);
                this.data(b);
                m()
            } else delete b.effect
        }
    });
    h.isTouch = z
})(jQuery);
(function (factory) {
    if (typeof define === "function" && define.amd) define(["jquery"], factory);
    else if (typeof exports === "object") module.exports = factory;
    else factory(jQuery)
})(function ($) {
    var toFix = ["wheel", "mousewheel", "DOMMouseScroll", "MozMousePixelScroll"],
        toBind = "onwheel" in document || document.documentMode >= 9 ? ["wheel"] : ["mousewheel", "DomMouseScroll", "MozMousePixelScroll"],
        slice = Array.prototype.slice,
        nullLowestDeltaTimeout, lowestDelta;
    if ($.event.fixHooks)
        for (var i = toFix.length; i;) $.event.fixHooks[toFix[--i]] =
            $.event.mouseHooks;
    $.event.special.mousewheel = {
        version: "3.1.6",
        setup: function () {
            if (this.addEventListener)
                for (var i = toBind.length; i;) this.addEventListener(toBind[--i], handler, false);
            else this.onmousewheel = handler
        },
        teardown: function () {
            if (this.removeEventListener)
                for (var i = toBind.length; i;) this.removeEventListener(toBind[--i], handler, false);
            else this.onmousewheel = null
        }
    };
    $.fn.extend({
        mousewheel: function (fn) {
            return fn ? this.bind("mousewheel", fn) : this.trigger("mousewheel")
        },
        unmousewheel: function (fn) {
            return this.unbind("mousewheel",
                fn)
        }
    });

    function handler(event) {
        var orgEvent = event || window.event,
            args = slice.call(arguments, 1),
            delta = 0,
            deltaX = 0,
            deltaY = 0,
            absDelta = 0;
        event = $.event.fix(orgEvent);
        event.type = "mousewheel";
        if ("detail" in orgEvent) deltaY = orgEvent.detail * -1;
        if ("wheelDelta" in orgEvent) deltaY = orgEvent.wheelDelta;
        if ("wheelDeltaY" in orgEvent) deltaY = orgEvent.wheelDeltaY;
        if ("wheelDeltaX" in orgEvent) deltaX = orgEvent.wheelDeltaX * -1;
        if ("axis" in orgEvent && orgEvent.axis === orgEvent.HORIZONTAL_AXIS) {
            deltaX = deltaY * -1;
            deltaY = 0
        }
        delta = deltaY ===
            0 ? deltaX : deltaY;
        if ("deltaY" in orgEvent) {
            deltaY = orgEvent.deltaY * -1;
            delta = deltaY
        }
        if ("deltaX" in orgEvent) {
            deltaX = orgEvent.deltaX;
            if (deltaY === 0) delta = deltaX * -1
        }
        if (deltaY === 0 && deltaX === 0) return;
        absDelta = Math.max(Math.abs(deltaY), Math.abs(deltaX));
        if (!lowestDelta || absDelta < lowestDelta) lowestDelta = absDelta;
        delta = Math[delta >= 1 ? "floor" : "ceil"](delta / lowestDelta);
        deltaX = Math[deltaX >= 1 ? "floor" : "ceil"](deltaX / lowestDelta);
        deltaY = Math[deltaY >= 1 ? "floor" : "ceil"](deltaY / lowestDelta);
        event.deltaX = deltaX;
        event.deltaY =
            deltaY;
        event.deltaFactor = lowestDelta;
        args.unshift(event, delta, deltaX, deltaY);
        if (nullLowestDeltaTimeout) clearTimeout(nullLowestDeltaTimeout);
        nullLowestDeltaTimeout = setTimeout(nullLowestDelta, 200);
        return ($.event.dispatch || $.event.handle).apply(this, args)
    }

    function nullLowestDelta() {
        lowestDelta = null
    }
});
(function ($) {
    $.transit = {
        version: "0.1.3",
        propertyMap: {
            marginLeft: "margin",
            marginRight: "margin",
            marginBottom: "margin",
            marginTop: "margin",
            paddingLeft: "padding",
            paddingRight: "padding",
            paddingBottom: "padding",
            paddingTop: "padding"
        },
        enabled: true,
        useTransitionEnd: false
    };
    var div = document.createElement("div");
    var support = {};

    function getVendorPropertyName(prop) {
        if (prop in div.style) return prop;
        var prefixes = ["Moz", "Webkit", "O", "ms"];
        var prop_ = prop.charAt(0).toUpperCase() + prop.substr(1);
        if (prop in div.style) return prop;
        for (var i = 0; i < prefixes.length; ++i) {
            var vendorProp = prefixes[i] + prop_;
            if (vendorProp in div.style) return vendorProp
        }
    }

    function checkTransform3dSupport() {
        div.style[support.transform] = "";
        div.style[support.transform] = "rotateY(90deg)";
        return div.style[support.transform] !== ""
    }
    var isChrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1;
    support.transition = getVendorPropertyName("transition");
    support.transitionDelay = getVendorPropertyName("transitionDelay");
    support.transform = getVendorPropertyName("transform");
    support.transformOrigin = getVendorPropertyName("transformOrigin");
    support.transform3d = checkTransform3dSupport();
    $.extend($.support, support);
    var eventNames = {
        "MozTransition": "transitionend",
        "OTransition": "oTransitionEnd",
        "WebkitTransition": "webkitTransitionEnd",
        "msTransition": "MSTransitionEnd"
    };
    var transitionEnd = support.transitionEnd = eventNames[support.transition] || null;
    div = null;
    $.cssEase = {
        "_default": "ease",
        "in": "ease-in",
        "out": "ease-out",
        "in-out": "ease-in-out",
        "snap": "cubic-bezier(0,1,.5,1)"
    };
    $.cssHooks.transform = {
        get: function (elem) {
            return $(elem).data("transform")
        },
        set: function (elem, v) {
            var value = v;
            if (!(value instanceof Transform)) value = new Transform(value);
            if (support.transform === "WebkitTransform" && !eb.browser.safari) elem.style[support.transform] = value.toString(true);
            else elem.style[support.transform] = value.toString();
            $(elem).data("transform", value)
        }
    };
    $.cssHooks.transformOrigin = {
        get: function (elem) {
            return elem.style[support.transformOrigin]
        },
        set: function (elem, value) {
            elem.style[support.transformOrigin] = value
        }
    };
    $.cssHooks.transition = {
        get: function (elem) {
            return elem.style[support.transition]
        },
        set: function (elem, value) {
            elem.style[support.transition] = value
        }
    };
    registerCssHook("scale");
    registerCssHook("translate");
    registerCssHook("rotate");
    registerCssHook("rotateX");
    registerCssHook("rotateY");
    registerCssHook("rotate3d");
    registerCssHook("perspective");
    registerCssHook("skewX");
    registerCssHook("skewY");
    registerCssHook("x", true);
    registerCssHook("y", true);

    function Transform(str) {
        if (typeof str === "string") this.parse(str);
        return this
    }
    Transform.prototype = {
        setFromString: function (prop, val) {
            var args = typeof val === "string" ? val.split(",") : val.constructor === Array ? val : [val];
            args.unshift(prop);
            Transform.prototype.set.apply(this, args)
        },
        set: function (prop) {
            var args = Array.prototype.slice.apply(arguments, [1]);
            if (this.setter[prop]) this.setter[prop].apply(this, args);
            else this[prop] = args.join(",")
        },
        get: function (prop) {
            if (this.getter[prop]) return this.getter[prop].apply(this);
            else return this[prop] || 0
        },
        setter: {
            rotate: function (theta) {
                this.rotate =
                    unit(theta, "deg")
            },
            rotateX: function (theta) {
                this.rotateX = unit(theta, "deg")
            },
            rotateY: function (theta) {
                this.rotateY = unit(theta, "deg")
            },
            scale: function (x, y) {
                if (y === undefined) y = x;
                this.scale = x + "," + y
            },
            skewX: function (x) {
                this.skewX = unit(x, "deg")
            },
            skewY: function (y) {
                this.skewY = unit(y, "deg")
            },
            perspective: function (dist) {
                this.perspective = unit(dist, "px")
            },
            x: function (x) {
                this.set("translate", x, null)
            },
            y: function (y) {
                this.set("translate", null, y)
            },
            translate: function (x, y) {
                if (this._translateX === undefined) this._translateX =
                    0;
                if (this._translateY === undefined) this._translateY = 0;
                if (x !== null) this._translateX = unit(x, "px");
                if (y !== null) this._translateY = unit(y, "px");
                this.translate = this._translateX + "," + this._translateY
            }
        },
        getter: {
            x: function () {
                return this._translateX || 0
            },
            y: function () {
                return this._translateY || 0
            },
            scale: function () {
                var s = (this.scale || "1,1").split(",");
                if (s[0]) s[0] = parseFloat(s[0]);
                if (s[1]) s[1] = parseFloat(s[1]);
                return s[0] === s[1] ? s[0] : s
            },
            rotate3d: function () {
                var s = (this.rotate3d || "0,0,0,0deg").split(",");
                for (var i = 0; i <=
                    3; ++i)
                    if (s[i]) s[i] = parseFloat(s[i]);
                if (s[3]) s[3] = unit(s[3], "deg");
                return s
            }
        },
        parse: function (str) {
            var self = this;
            str.replace(/([a-zA-Z0-9]+)\((.*?)\)/g, function (x, prop, val) {
                self.setFromString(prop, val)
            })
        },
        toString: function (use3d) {
            var re = [];
            for (var i in this)
                if (this.hasOwnProperty(i)) {
                    if (!support.transform3d && (i === "rotateX" || i === "rotateY" || i === "perspective" || i === "transformOrigin")) continue;
                    if (i[0] !== "_")
                        if (use3d && i === "scale") re.push(i + "3d(" + this[i] + ",1)");
                        else if (use3d && i === "translate") re.push(i + "3d(" +
                        this[i] + ",0)");
                    else re.push(i + "(" + this[i] + ")")
                }
            return re.join(" ")
        }
    };

    function callOrQueue(self, queue, fn) {
        if (queue === true) self.queue(fn);
        else if (queue) self.queue(queue, fn);
        else fn()
    }

    function getProperties(props) {
        var re = [];
        $.each(props, function (key) {
            key = $.camelCase(key);
            key = $.transit.propertyMap[key] || key;
            key = uncamel(key);
            if ($.inArray(key, re) === -1) re.push(key)
        });
        return re
    }

    function getTransition(properties, duration, easing, delay) {
        var props = getProperties(properties);
        if ($.cssEase[easing]) easing = $.cssEase[easing];
        var attribs = "" + toMS(duration) + " " + easing;
        if (parseInt(delay, 10) > 0) attribs += " " + toMS(delay);
        var transitions = [];
        $.each(props, function (i, name) {
            transitions.push(name + " " + attribs)
        });
        return transitions.join(", ")
    }
    $.fn.transition = $.fn.transit = function (properties, duration, easing, callback) {
        var self = this;
        var delay = 0;
        var queue = true;
        if (typeof duration === "function") {
            callback = duration;
            duration = undefined
        }
        if (typeof easing === "function") {
            callback = easing;
            easing = undefined
        }
        if (typeof properties.easing !== "undefined") {
            easing =
                properties.easing;
            delete properties.easing
        }
        if (typeof properties.duration !== "undefined") {
            duration = properties.duration;
            delete properties.duration
        }
        if (typeof properties.complete !== "undefined") {
            callback = properties.complete;
            delete properties.complete
        }
        if (typeof properties.queue !== "undefined") {
            queue = properties.queue;
            delete properties.queue
        }
        if (typeof properties.delay !== "undefined") {
            delay = properties.delay;
            delete properties.delay
        }
        if (typeof duration === "undefined") duration = $.fx.speeds._default;
        if (typeof easing ===
            "undefined") easing = $.cssEase._default;
        duration = toMS(duration);
        var transitionValue = getTransition(properties, duration, easing, delay);
        var work = $.transit.enabled && support.transition;
        var i = work ? parseInt(duration, 10) + parseInt(delay, 10) : 0;
        if (i === 0) {
            var fn = function (next) {
                self.css(properties);
                if (callback) callback.apply(self);
                if (next) next()
            };
            callOrQueue(self, queue, fn);
            return self
        }
        var oldTransitions = {};
        var run = function (nextCall) {
            var bound = false;
            var cb = function () {
                if (bound) self.unbind(transitionEnd, cb);
                if (i > 0) self.each(function () {
                    this.style[support.transition] =
                        oldTransitions[this] || null
                });
                if (typeof callback === "function") callback.apply(self);
                if (typeof nextCall === "function") nextCall()
            };
            if (i > 0 && transitionEnd && $.transit.useTransitionEnd) {
                bound = true;
                self.bind(transitionEnd, cb)
            } else window.setTimeout(cb, i);
            self.each(function () {
                if (i > 0) this.style[support.transition] = transitionValue;
                $(this).css(properties)
            })
        };
        var deferredRun = function (next) {
            var i = 0;
            this.offsetWidth;
            run(next)
        };
        callOrQueue(self, queue, deferredRun);
        return this
    };

    function registerCssHook(prop, isPixels) {
        if (!isPixels) $.cssNumber[prop] =
            true;
        $.transit.propertyMap[prop] = support.transform;
        $.cssHooks[prop] = {
            get: function (elem) {
                var t = $(elem).css("transform");
                if (!(t instanceof Transform)) t = new Transform;
                return t.get(prop)
            },
            set: function (elem, value) {
                var t = $(elem).css("transform");
                if (!(t instanceof Transform)) t = new Transform;
                t.setFromString(prop, value);
                $(elem).css({
                    transform: t
                })
            }
        }
    }

    function uncamel(str) {
        return str.replace(/([A-Z])/g, function (letter) {
            return "-" + letter.toLowerCase()
        })
    }

    function unit(i, units) {
        if (typeof i === "string" && !i.match(/^[\-0-9\.]+$/)) return i;
        else return "" + i + units
    }

    function toMS(duration) {
        var i = duration;
        if ($.fx.speeds[i]) i = $.fx.speeds[i];
        return unit(i, "ms")
    }
    $.transit.getTransitionValue = getTransition
})(jQuery);
//fgnass.github.com/spin.js#v1.2.5
(function (a, b, c) {
    function g(a, c) {
        var d = b.createElement(a || "div"),
            e;
        for (e in c) d[e] = c[e];
        return d
    }

    function h(a) {
        for (var b = 1, c = arguments.length; b < c; b++) a.appendChild(arguments[b]);
        return a
    }

    function j(a, b, c, d) {
        var g = ["opacity", b, ~~ (a * 100), c, d].join("-"),
            h = .01 + c / d * 100,
            j = Math.max(1 - (1 - a) / b * (100 - h), a),
            k = f.substring(0, f.indexOf("Animation")).toLowerCase(),
            l = k && "-" + k + "-" || "";
        return e[g] || (i.insertRule("@" + l + "keyframes " + g + "{" + "0%{opacity:" + j + "}" + h + "%{opacity:" + a + "}" + (h + .01) + "%{opacity:1}" + (h + b) % 100 + "%{opacity:" + a + "}" + "100%{opacity:" + j + "}" + "}", 0), e[g] = 1), g
    }

    function k(a, b) {
        var e = a.style,
            f, g;
        if (e[b] !== c) return b;
        b = b.charAt(0).toUpperCase() + b.slice(1);
        for (g = 0; g < d.length; g++) {
            f = d[g] + b;
            if (e[f] !== c) return f
        }
    }

    function l(a, b) {
        for (var c in b) a.style[k(a, c) || c] = b[c];
        return a
    }

    function m(a) {
        for (var b = 1; b < arguments.length; b++) {
            var d = arguments[b];
            for (var e in d) a[e] === c && (a[e] = d[e])
        }
        return a
    }

    function n(a) {
        var b = {
            x: a.offsetLeft,
            y: a.offsetTop
        };
        while (a = a.offsetParent) b.x += a.offsetLeft, b.y += a.offsetTop;
        return b
    }
    var d = ["webkit", "Moz", "ms", "O"],
        e = {}, f, i = function () {
            var a = g("style");
            return h(b.getElementsByTagName("head")[0], a), a.sheet || a.styleSheet
        }(),
        o = {
            lines: 12,
            length: 7,
            width: 5,
            radius: 10,
            rotate: 0,
            color: "#000",
            speed: 1,
            trail: 100,
            opacity: .25,
            fps: 20,
            zIndex: 2e9,
            className: "spinner",
            top: "auto",
            left: "auto"
        }, p = function q(a) {
            if (!this.spin) return new q(a);
            this.opts = m(a || {}, q.defaults, o)
        };
    p.defaults = {}, m(p.prototype, {
        spin: function (a) {
            this.stop();
            var b = this,
                c = b.opts,
                d = b.el = l(g(0, {
                    className: c.className
                }), {
                    position: "relative",
                    zIndex: c.zIndex
                }),
                e = c.radius + c.length + c.width,
                h, i;
            a && (a.insertBefore(d, a.firstChild || null), i = n(a), h = n(d), l(d, {
                left: (c.left == "auto" ? i.x - h.x + (a.offsetWidth >> 1) : c.left + e) + "px",
                top: (c.top == "auto" ? i.y - h.y + (a.offsetHeight >> 1) : c.top + e) + "px"
            })), d.setAttribute("aria-role", "progressbar"), b.lines(d, b.opts);
            if (!f) {
                var j = 0,
                    k = c.fps,
                    m = k / c.speed,
                    o = (1 - c.opacity) / (m * c.trail / 100),
                    p = m / c.lines;
                ! function q() {
                    j++;
                    for (var a = c.lines; a; a--) {
                        var e = Math.max(1 - (j + a * p) % m * o, c.opacity);
                        b.opacity(d, c.lines - a, e, c)
                    }
                    b.timeout = b.el && setTimeout(q, ~~ (1e3 / k))
                }()
            }
            return b
        },
        stop: function () {
            var a = this.el;
            return a && (clearTimeout(this.timeout), a.parentNode && a.parentNode.removeChild(a), this.el = c), this
        },
        lines: function (a, b) {
            function e(a, d) {
                return l(g(), {
                    position: "absolute",
                    width: b.length + b.width + "px",
                    height: b.width + "px",
                    background: a,
                    boxShadow: d,
                    transformOrigin: "left",
                    transform: "rotate(" + ~~(360 / b.lines * c + b.rotate) + "deg) translate(" + b.radius + "px" + ",0)",
                    borderRadius: (b.width >> 1) + "px"
                })
            }
            var c = 0,
                d;
            for (; c < b.lines; c++) d = l(g(), {
                position: "absolute",
                top: 1 + ~(b.width / 2) + "px",
                transform: b.hwaccel ? "translate3d(0,0,0)" : "",
                opacity: b.opacity,
                animation: f && j(b.opacity, b.trail, c, b.lines) + " " + 1 / b.speed + "s linear infinite"
            }), b.shadow && h(d, l(e("#000", "0 0 4px #000"), {
                top: "2px"
            })), h(a, h(d, e(b.color, "0 0 1px rgba(0,0,0,.1)")));
            return a
        },
        opacity: function (a, b, c) {
            b < a.childNodes.length && (a.childNodes[b].style.opacity = c)
        }
    }), ! function () {
        function a(a, b) {
            return g("<" + a + ' xmlns="urn:schemas-microsoft.com:vml" class="spin-vml">', b)
        }
        var b = l(g("group"), {
            behavior: "url(#default#VML)"
        });
        !k(b, "transform") && b.adj ? (i.addRule(".spin-vml", "behavior:url(#default#VML)"), p.prototype.lines = function (b, c) {
            function f() {
                return l(a("group", {
                    coordsize: e + " " + e,
                    coordorigin: -d + " " + -d
                }), {
                    width: e,
                    height: e
                })
            }

            function k(b, e, g) {
                h(i, h(l(f(), {
                    rotation: 360 / c.lines * b + "deg",
                    left: ~~e
                }), h(l(a("roundrect", {
                    arcsize: 1
                }), {
                    width: d,
                    height: c.width,
                    left: c.radius,
                    top: -c.width >> 1,
                    filter: g
                }), a("fill", {
                    color: c.color,
                    opacity: c.opacity
                }), a("stroke", {
                    opacity: 0
                }))))
            }
            var d = c.length + c.width,
                e = 2 * d,
                g = -(c.width + c.length) * 2 + "px",
                i = l(f(), {
                    position: "absolute",
                    top: g,
                    left: g
                }),
                j;
            if (c.shadow)
                for (j = 1; j <= c.lines; j++) k(j, -2, "progid:DXImageTransform.Microsoft.Blur(pixelradius=2,makeshadow=1,shadowopacity=.3)");
            for (j = 1; j <= c.lines; j++) k(j);
            return h(b, i)
        }, p.prototype.opacity = function (a, b, c, d) {
            var e = a.firstChild;
            d = d.shadow && d.lines || 0, e && b + d < e.childNodes.length && (e = e.childNodes[b + d], e = e && e.firstChild, e = e && e.firstChild, e && (e.opacity = c))
        }) : f = k(b, "animation")
    }(), a.Spinner = p
})(window, document);
(function ($) {
    $.fn.visible = function (partial, transitionSelector) {
        if (transitionSelector) {
            var container = jQuery(transitionSelector);
            var $t = $(this);
            var scale = parseFloat(jQuery(transitionSelector + "_parent").css("scale"));
            var leftmargin = (jQuery(transitionSelector + "_parent").width() - jQuery(transitionSelector).width()) * scale;
            var translateX = jQuery(transitionSelector).offset().left * -1;
            var translateY = jQuery(transitionSelector).offset().top * -1;
            var parent_w = $t.parent().width();
            var parent_h = $t.parent().height();
            var t_id = $(this).attr("id");
            var page_id = t_id.substr(10, t_id.indexOf("_", 10) - 10);
            var square_id = t_id.substr(-4);
            var square_pct_left = 0;
            var square_pct_top = 0;
            var left_page = page_id % 2 != 0;
            switch (square_id) {
            case "l1t1":
                square_pct_left = 0;
                square_pct_top = 0;
                break;
            case "l2t1":
                square_pct_left = 0.25;
                square_pct_top = 0;
                break;
            case "l1t2":
                square_pct_left = 0;
                square_pct_top = 0.25;
                break;
            case "l2t2":
                square_pct_left = 0.25;
                square_pct_top = 0.25;
                break;
            case "r1t1":
                square_pct_left = 0.5;
                square_pct_top = 0;
                break;
            case "r2t1":
                square_pct_left =
                    0.75;
                square_pct_top = 0;
                break;
            case "r1t2":
                square_pct_left = 0.5;
                square_pct_top = 0.25;
                break;
            case "r2t2":
                square_pct_left = 0.75;
                square_pct_top = 0.25;
                break;
            case "l1b1":
                square_pct_left = 0;
                square_pct_top = 0.5;
                break;
            case "l2b1":
                square_pct_left = 0.25;
                square_pct_top = 0.5;
                break;
            case "l1b2":
                square_pct_left = 0;
                square_pct_top = 0.75;
                break;
            case "l2b2":
                square_pct_left = 0.25;
                square_pct_top = 0.75;
                break;
            case "r1b1":
                square_pct_left = 0.5;
                square_pct_top = 0.5;
                break;
            case "r2b1":
                square_pct_left = 0.75;
                square_pct_top = 0.5;
                break;
            case "r1b2":
                square_pct_left =
                    0.5;
                square_pct_top = 0.75;
                break;
            case "r2b2":
                square_pct_left = 0.75;
                square_pct_top = 0.75;
                break
            }
            var elementTop = parent_h * square_pct_top;
            var elementLeft = parent_w * square_pct_left;
            var $w = container,
                viewTop = translateY,
                viewBottom = viewTop + $w.height(),
                viewLeft = translateX,
                viewRight = viewLeft + $w.width();
            _top = elementTop * scale, _bottom = _top + $t.height() * scale, _left = (elementLeft + $t.width()) * scale, _right = (_left - $w.width()) * scale, compareTop = partial === true ? _bottom : _top, compareBottom = partial === true ? _top : _bottom, compareLeft =
                partial === true ? _left : _right, compareRight = partial === true ? _right : _left;
            var vvisible = compareBottom <= viewBottom && compareTop >= viewTop;
            var hvisible = compareLeft + (!left_page ? $w.width() * scale : 0) >= viewLeft;
            if (square_id == "l1t1");
            return vvisible && hvisible
        } else {
            var $t = $(this),
                $w = $(window),
                viewTop = $w.scrollTop(),
                viewBottom = viewTop + $w.height(),
                _top = $t.offset().top,
                _bottom = _top + $t.height(),
                compareTop = partial === true ? _bottom : _top,
                compareBottom = partial === true ? _top : _bottom;
            return compareBottom <= viewBottom && compareTop >=
                viewTop
        }
    }
})(jQuery);