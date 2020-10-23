/*!
 * shariff - v1.25.2 - 29.06.2017
 * https://github.com/heiseonline/shariff
 * Copyright (c) 2017 Ines Pauer, Philipp Busse, Sebastian Hilbig, Erich Kramer, Deniz Sesli
 * Licensed under the MIT license
 */
(function e(t, n, r) {
    function s(o, u) {
        if (!n[o]) {
            if (!t[o]) {
                var a = typeof require == "function" && require;
                if (!u && a) return a(o, !0);
                if (i) return i(o, !0);
                var f = new Error("Cannot find module '" + o + "'");
                throw f.code = "MODULE_NOT_FOUND", f
            }
            var l = n[o] = {
                exports: {}
            };
            t[o][0].call(l.exports, function(e) {
                var n = t[o][1][e];
                return s(n ? n : e)
            }, l, l.exports, e, t, n, r)
        }
        return n[o].exports
    }
    var i = typeof require == "function" && require;
    for (var o = 0; o < r.length; o++) s(r[o]);
    return s
})({
    1: [function(require, module, exports) {
        "use strict";

        function Url() {
            this.protocol = null, this.slashes = null, this.auth = null, this.host = null, this.port = null, this.hostname = null, this.hash = null, this.search = null, this.query = null, this.pathname = null, this.path = null, this.href = null
        }

        function urlParse(t, s, e) {
            if (t && util.isObject(t) && t instanceof Url) return t;
            var h = new Url;
            return h.parse(t, s, e), h
        }

        function urlFormat(t) {
            return util.isString(t) && (t = urlParse(t)), t instanceof Url ? t.format() : Url.prototype.format.call(t)
        }

        function urlResolve(t, s) {
            return urlParse(t, !1, !0).resolve(s)
        }

        function urlResolveObject(t, s) {
            return t ? urlParse(t, !1, !0).resolveObject(s) : s
        }
        var punycode = require("punycode"),
            util = require("./util");
        exports.parse = urlParse, exports.resolve = urlResolve, exports.resolveObject = urlResolveObject, exports.format = urlFormat, exports.Url = Url;
        var protocolPattern = /^([a-z0-9.+-]+:)/i,
            portPattern = /:[0-9]*$/,
            simplePathPattern = /^(\/\/?(?!\/)[^\?\s]*)(\?[^\s]*)?$/,
            delims = ["<", ">", '"', "`", " ", "\r", "\n", "\t"],
            unwise = ["{", "}", "|", "\\", "^", "`"].concat(delims),
            autoEscape = ["'"].concat(unwise),
            nonHostChars = ["%", "/", "?", ";", "#"].concat(autoEscape),
            hostEndingChars = ["/", "?", "#"],
            hostnameMaxLen = 255,
            hostnamePartPattern = /^[+a-z0-9A-Z_-]{0,63}$/,
            hostnamePartStart = /^([+a-z0-9A-Z_-]{0,63})(.*)$/,
            unsafeProtocol = {
                javascript: !0,
                "javascript:": !0
            },
            hostlessProtocol = {
                javascript: !0,
                "javascript:": !0
            },
            slashedProtocol = {
                http: !0,
                https: !0,
                ftp: !0,
                gopher: !0,
                file: !0,
                "http:": !0,
                "https:": !0,
                "ftp:": !0,
                "gopher:": !0,
                "file:": !0
            },
            querystring = require("querystring");
        Url.prototype.parse = function(t, s, e) {
            if (!util.isString(t)) throw new TypeError("Parameter 'url' must be a string, not " + typeof t);
            var h = t.indexOf("?"),
                r = -1 !== h && h < t.indexOf("#") ? "?" : "#",
                a = t.split(r);
            a[0] = a[0].replace(/\\/g, "/"), t = a.join(r);
            var o = t;
            if (o = o.trim(), !e && 1 === t.split("#").length) {
                var n = simplePathPattern.exec(o);
                if (n) return this.path = o, this.href = o, this.pathname = n[1], n[2] ? (this.search = n[2], this.query = s ? querystring.parse(this.search.substr(1)) : this.search.substr(1)) : s && (this.search = "", this.query = {}), this
            }
            var i = protocolPattern.exec(o);
            if (i) {
                i = i[0];
                var l = i.toLowerCase();
                this.protocol = l, o = o.substr(i.length)
            }
            if (e || i || o.match(/^\/\/[^@\/]+@[^@\/]+/)) {
                var u = "//" === o.substr(0, 2);
                !u || i && hostlessProtocol[i] || (o = o.substr(2), this.slashes = !0)
            }
            if (!hostlessProtocol[i] && (u || i && !slashedProtocol[i])) {
                for (var p = -1, c = 0; c < hostEndingChars.length; c++) {
                    var f = o.indexOf(hostEndingChars[c]); - 1 !== f && (-1 === p || f < p) && (p = f)
                }
                var m, v;
                v = -1 === p ? o.lastIndexOf("@") : o.lastIndexOf("@", p), -1 !== v && (m = o.slice(0, v), o = o.slice(v + 1), this.auth = decodeURIComponent(m)), p = -1;
                for (var c = 0; c < nonHostChars.length; c++) {
                    var f = o.indexOf(nonHostChars[c]); - 1 !== f && (-1 === p || f < p) && (p = f)
                } - 1 === p && (p = o.length), this.host = o.slice(0, p), o = o.slice(p), this.parseHost(), this.hostname = this.hostname || "";
                var g = "[" === this.hostname[0] && "]" === this.hostname[this.hostname.length - 1];
                if (!g)
                    for (var y = this.hostname.split(/\./), c = 0, P = y.length; c < P; c++) {
                        var d = y[c];
                        if (d && !d.match(hostnamePartPattern)) {
                            for (var b = "", q = 0, O = d.length; q < O; q++) d.charCodeAt(q) > 127 ? b += "x" : b += d[q];
                            if (!b.match(hostnamePartPattern)) {
                                var j = y.slice(0, c),
                                    x = y.slice(c + 1),
                                    U = d.match(hostnamePartStart);
                                U && (j.push(U[1]), x.unshift(U[2])), x.length && (o = "/" + x.join(".") + o), this.hostname = j.join(".");
                                break
                            }
                        }
                    }
                this.hostname.length > hostnameMaxLen ? this.hostname = "" : this.hostname = this.hostname.toLowerCase(), g || (this.hostname = punycode.toASCII(this.hostname));
                var C = this.port ? ":" + this.port : "",
                    A = this.hostname || "";
                this.host = A + C, this.href += this.host, g && (this.hostname = this.hostname.substr(1, this.hostname.length - 2), "/" !== o[0] && (o = "/" + o))
            }
            if (!unsafeProtocol[l])
                for (var c = 0, P = autoEscape.length; c < P; c++) {
                    var w = autoEscape[c];
                    if (-1 !== o.indexOf(w)) {
                        var E = encodeURIComponent(w);
                        E === w && (E = escape(w)), o = o.split(w).join(E)
                    }
                }
            var I = o.indexOf("#"); - 1 !== I && (this.hash = o.substr(I), o = o.slice(0, I));
            var R = o.indexOf("?");
            if (-1 !== R ? (this.search = o.substr(R), this.query = o.substr(R + 1), s && (this.query = querystring.parse(this.query)), o = o.slice(0, R)) : s && (this.search = "", this.query = {}), o && (this.pathname = o), slashedProtocol[l] && this.hostname && !this.pathname && (this.pathname = "/"), this.pathname || this.search) {
                var C = this.pathname || "",
                    S = this.search || "";
                this.path = C + S
            }
            return this.href = this.format(), this
        }, Url.prototype.format = function() {
            var t = this.auth || "";
            t && (t = encodeURIComponent(t), t = t.replace(/%3A/i, ":"), t += "@");
            var s = this.protocol || "",
                e = this.pathname || "",
                h = this.hash || "",
                r = !1,
                a = "";
            this.host ? r = t + this.host : this.hostname && (r = t + (-1 === this.hostname.indexOf(":") ? this.hostname : "[" + this.hostname + "]"), this.port && (r += ":" + this.port)), this.query && util.isObject(this.query) && Object.keys(this.query).length && (a = querystring.stringify(this.query));
            var o = this.search || a && "?" + a || "";
            return s && ":" !== s.substr(-1) && (s += ":"), this.slashes || (!s || slashedProtocol[s]) && !1 !== r ? (r = "//" + (r || ""), e && "/" !== e.charAt(0) && (e = "/" + e)) : r || (r = ""), h && "#" !== h.charAt(0) && (h = "#" + h), o && "?" !== o.charAt(0) && (o = "?" + o), e = e.replace(/[?#]/g, function(t) {
                return encodeURIComponent(t)
            }), o = o.replace("#", "%23"), s + r + e + o + h
        }, Url.prototype.resolve = function(t) {
            return this.resolveObject(urlParse(t, !1, !0)).format()
        }, Url.prototype.resolveObject = function(t) {
            if (util.isString(t)) {
                var s = new Url;
                s.parse(t, !1, !0), t = s
            }
            for (var e = new Url, h = Object.keys(this), r = 0; r < h.length; r++) {
                var a = h[r];
                e[a] = this[a]
            }
            if (e.hash = t.hash, "" === t.href) return e.href = e.format(), e;
            if (t.slashes && !t.protocol) {
                for (var o = Object.keys(t), n = 0; n < o.length; n++) {
                    var i = o[n];
                    "protocol" !== i && (e[i] = t[i])
                }
                return slashedProtocol[e.protocol] && e.hostname && !e.pathname && (e.path = e.pathname = "/"), e.href = e.format(), e
            }
            if (t.protocol && t.protocol !== e.protocol) {
                if (!slashedProtocol[t.protocol]) {
                    for (var l = Object.keys(t), u = 0; u < l.length; u++) {
                        var p = l[u];
                        e[p] = t[p]
                    }
                    return e.href = e.format(), e
                }
                if (e.protocol = t.protocol, t.host || hostlessProtocol[t.protocol]) e.pathname = t.pathname;
                else {
                    for (var c = (t.pathname || "").split("/"); c.length && !(t.host = c.shift()););
                    t.host || (t.host = ""), t.hostname || (t.hostname = ""), "" !== c[0] && c.unshift(""), c.length < 2 && c.unshift(""), e.pathname = c.join("/")
                }
                if (e.search = t.search, e.query = t.query, e.host = t.host || "", e.auth = t.auth, e.hostname = t.hostname || t.host, e.port = t.port, e.pathname || e.search) {
                    var f = e.pathname || "",
                        m = e.search || "";
                    e.path = f + m
                }
                return e.slashes = e.slashes || t.slashes, e.href = e.format(), e
            }
            var v = e.pathname && "/" === e.pathname.charAt(0),
                g = t.host || t.pathname && "/" === t.pathname.charAt(0),
                y = g || v || e.host && t.pathname,
                P = y,
                d = e.pathname && e.pathname.split("/") || [],
                c = t.pathname && t.pathname.split("/") || [],
                b = e.protocol && !slashedProtocol[e.protocol];
            if (b && (e.hostname = "", e.port = null, e.host && ("" === d[0] ? d[0] = e.host : d.unshift(e.host)), e.host = "", t.protocol && (t.hostname = null, t.port = null, t.host && ("" === c[0] ? c[0] = t.host : c.unshift(t.host)), t.host = null), y = y && ("" === c[0] || "" === d[0])), g) e.host = t.host || "" === t.host ? t.host : e.host, e.hostname = t.hostname || "" === t.hostname ? t.hostname : e.hostname, e.search = t.search, e.query = t.query, d = c;
            else if (c.length) d || (d = []), d.pop(), d = d.concat(c), e.search = t.search, e.query = t.query;
            else if (!util.isNullOrUndefined(t.search)) {
                if (b) {
                    e.hostname = e.host = d.shift();
                    var q = !!(e.host && e.host.indexOf("@") > 0) && e.host.split("@");
                    q && (e.auth = q.shift(), e.host = e.hostname = q.shift())
                }
                return e.search = t.search, e.query = t.query, util.isNull(e.pathname) && util.isNull(e.search) || (e.path = (e.pathname ? e.pathname : "") + (e.search ? e.search : "")), e.href = e.format(), e
            }
            if (!d.length) return e.pathname = null, e.search ? e.path = "/" + e.search : e.path = null, e.href = e.format(), e;
            for (var O = d.slice(-1)[0], j = (e.host || t.host || d.length > 1) && ("." === O || ".." === O) || "" === O, x = 0, U = d.length; U >= 0; U--) O = d[U], "." === O ? d.splice(U, 1) : ".." === O ? (d.splice(U, 1), x++) : x && (d.splice(U, 1), x--);
            if (!y && !P)
                for (; x--; x) d.unshift("..");
            !y || "" === d[0] || d[0] && "/" === d[0].charAt(0) || d.unshift(""), j && "/" !== d.join("/").substr(-1) && d.push("");
            var C = "" === d[0] || d[0] && "/" === d[0].charAt(0);
            if (b) {
                e.hostname = e.host = C ? "" : d.length ? d.shift() : "";
                var q = !!(e.host && e.host.indexOf("@") > 0) && e.host.split("@");
                q && (e.auth = q.shift(), e.host = e.hostname = q.shift())
            }
            return y = y || e.host && d.length, y && !C && d.unshift(""), d.length ? e.pathname = d.join("/") : (e.pathname = null, e.path = null), util.isNull(e.pathname) && util.isNull(e.search) || (e.path = (e.pathname ? e.pathname : "") + (e.search ? e.search : "")), e.auth = t.auth || e.auth, e.slashes = e.slashes || t.slashes, e.href = e.format(), e
        }, Url.prototype.parseHost = function() {
            var t = this.host,
                s = portPattern.exec(t);
            s && (s = s[0], ":" !== s && (this.port = s.substr(1)), t = t.substr(0, t.length - s.length)), t && (this.hostname = t)
        };

    }, {
        "./util": 2,
        "punycode": 3,
        "querystring": 6
    }],
    2: [function(require, module, exports) {
        "use strict";
        module.exports = {
            isString: function(n) {
                return "string" == typeof n
            },
            isObject: function(n) {
                return "object" == typeof n && null !== n
            },
            isNull: function(n) {
                return null === n
            },
            isNullOrUndefined: function(n) {
                return null == n
            }
        };

    }, {}],
    3: [function(require, module, exports) {
        (function(global) {
            ! function(e) {
                function o(e) {
                    throw new RangeError(T[e])
                }

                function n(e, o) {
                    for (var n = e.length, t = []; n--;) t[n] = o(e[n]);
                    return t
                }

                function t(e, o) {
                    var t = e.split("@"),
                        r = "";
                    return t.length > 1 && (r = t[0] + "@", e = t[1]), e = e.replace(S, "."), r + n(e.split("."), o).join(".")
                }

                function r(e) {
                    for (var o, n, t = [], r = 0, u = e.length; r < u;) o = e.charCodeAt(r++), o >= 55296 && o <= 56319 && r < u ? (n = e.charCodeAt(r++), 56320 == (64512 & n) ? t.push(((1023 & o) << 10) + (1023 & n) + 65536) : (t.push(o), r--)) : t.push(o);
                    return t
                }

                function u(e) {
                    return n(e, function(e) {
                        var o = "";
                        return e > 65535 && (e -= 65536, o += P(e >>> 10 & 1023 | 55296), e = 56320 | 1023 & e), o += P(e)
                    }).join("")
                }

                function i(e) {
                    return e - 48 < 10 ? e - 22 : e - 65 < 26 ? e - 65 : e - 97 < 26 ? e - 97 : b
                }

                function f(e, o) {
                    return e + 22 + 75 * (e < 26) - ((0 != o) << 5)
                }

                function c(e, o, n) {
                    var t = 0;
                    for (e = n ? M(e / j) : e >> 1, e += M(e / o); e > L * C >> 1; t += b) e = M(e / L);
                    return M(t + (L + 1) * e / (e + m))
                }

                function l(e) {
                    var n, t, r, f, l, s, d, p, a, h, v = [],
                        g = e.length,
                        w = 0,
                        m = I,
                        j = A;
                    for (t = e.lastIndexOf(E), t < 0 && (t = 0), r = 0; r < t; ++r) e.charCodeAt(r) >= 128 && o("not-basic"), v.push(e.charCodeAt(r));
                    for (f = t > 0 ? t + 1 : 0; f < g;) {
                        for (l = w, s = 1, d = b; f >= g && o("invalid-input"), p = i(e.charCodeAt(f++)), (p >= b || p > M((x - w) / s)) && o("overflow"), w += p * s, a = d <= j ? y : d >= j + C ? C : d - j, !(p < a); d += b) h = b - a, s > M(x / h) && o("overflow"), s *= h;
                        n = v.length + 1, j = c(w - l, n, 0 == l), M(w / n) > x - m && o("overflow"), m += M(w / n), w %= n, v.splice(w++, 0, m)
                    }
                    return u(v)
                }

                function s(e) {
                    var n, t, u, i, l, s, d, p, a, h, v, g, w, m, j, F = [];
                    for (e = r(e), g = e.length, n = I, t = 0, l = A, s = 0; s < g; ++s)(v = e[s]) < 128 && F.push(P(v));
                    for (u = i = F.length, i && F.push(E); u < g;) {
                        for (d = x, s = 0; s < g; ++s)(v = e[s]) >= n && v < d && (d = v);
                        for (w = u + 1, d - n > M((x - t) / w) && o("overflow"), t += (d - n) * w, n = d, s = 0; s < g; ++s)
                            if (v = e[s], v < n && ++t > x && o("overflow"), v == n) {
                                for (p = t, a = b; h = a <= l ? y : a >= l + C ? C : a - l, !(p < h); a += b) j = p - h, m = b - h, F.push(P(f(h + j % m, 0))), p = M(j / m);
                                F.push(P(f(p, 0))), l = c(t, w, u == i), t = 0, ++u
                            }++t, ++n
                    }
                    return F.join("")
                }

                function d(e) {
                    return t(e, function(e) {
                        return F.test(e) ? l(e.slice(4).toLowerCase()) : e
                    })
                }

                function p(e) {
                    return t(e, function(e) {
                        return O.test(e) ? "xn--" + s(e) : e
                    })
                }
                var a = "object" == typeof exports && exports && !exports.nodeType && exports,
                    h = "object" == typeof module && module && !module.nodeType && module,
                    v = "object" == typeof global && global;
                v.global !== v && v.window !== v && v.self !== v || (e = v);
                var g, w, x = 2147483647,
                    b = 36,
                    y = 1,
                    C = 26,
                    m = 38,
                    j = 700,
                    A = 72,
                    I = 128,
                    E = "-",
                    F = /^xn--/,
                    O = /[^\x20-\x7E]/,
                    S = /[\x2E\u3002\uFF0E\uFF61]/g,
                    T = {
                        overflow: "Overflow: input needs wider integers to process",
                        "not-basic": "Illegal input >= 0x80 (not a basic code point)",
                        "invalid-input": "Invalid input"
                    },
                    L = b - y,
                    M = Math.floor,
                    P = String.fromCharCode;
                if (g = {
                        version: "1.4.1",
                        ucs2: {
                            decode: r,
                            encode: u
                        },
                        decode: l,
                        encode: s,
                        toASCII: p,
                        toUnicode: d
                    }, "function" == typeof define && "object" == typeof define.amd && define.amd) define("punycode", function() {
                    return g
                });
                else if (a && h)
                    if (module.exports == a) h.exports = g;
                    else
                        for (w in g) g.hasOwnProperty(w) && (a[w] = g[w]);
                else e.punycode = g
            }(this);
        }).call(this, typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
    }, {}],
    4: [function(require, module, exports) {
        "use strict";

        function hasOwnProperty(r, e) {
            return Object.prototype.hasOwnProperty.call(r, e)
        }
        module.exports = function(r, e, t, n) {
            e = e || "&", t = t || "=";
            var o = {};
            if ("string" != typeof r || 0 === r.length) return o;
            r = r.split(e);
            var a = 1e3;
            n && "number" == typeof n.maxKeys && (a = n.maxKeys);
            var s = r.length;
            a > 0 && s > a && (s = a);
            for (var p = 0; p < s; ++p) {
                var y, u, c, i, l = r[p].replace(/\+/g, "%20"),
                    f = l.indexOf(t);
                f >= 0 ? (y = l.substr(0, f), u = l.substr(f + 1)) : (y = l, u = ""), c = decodeURIComponent(y), i = decodeURIComponent(u), hasOwnProperty(o, c) ? isArray(o[c]) ? o[c].push(i) : o[c] = [o[c], i] : o[c] = i
            }
            return o
        };
        var isArray = Array.isArray || function(r) {
            return "[object Array]" === Object.prototype.toString.call(r)
        };
    }, {}],
    5: [function(require, module, exports) {
        "use strict";

        function map(r, e) {
            if (r.map) return r.map(e);
            for (var t = [], n = 0; n < r.length; n++) t.push(e(r[n], n));
            return t
        }
        var stringifyPrimitive = function(r) {
            switch (typeof r) {
                case "string":
                    return r;
                case "boolean":
                    return r ? "true" : "false";
                case "number":
                    return isFinite(r) ? r : "";
                default:
                    return ""
            }
        };
        module.exports = function(r, e, t, n) {
            return e = e || "&", t = t || "=", null === r && (r = void 0), "object" == typeof r ? map(objectKeys(r), function(n) {
                var i = encodeURIComponent(stringifyPrimitive(n)) + t;
                return isArray(r[n]) ? map(r[n], function(r) {
                    return i + encodeURIComponent(stringifyPrimitive(r))
                }).join(e) : i + encodeURIComponent(stringifyPrimitive(r[n]))
            }).join(e) : n ? encodeURIComponent(stringifyPrimitive(n)) + t + encodeURIComponent(stringifyPrimitive(r)) : ""
        };
        var isArray = Array.isArray || function(r) {
                return "[object Array]" === Object.prototype.toString.call(r)
            },
            objectKeys = Object.keys || function(r) {
                var e = [];
                for (var t in r) Object.prototype.hasOwnProperty.call(r, t) && e.push(t);
                return e
            };

    }, {}],
    6: [function(require, module, exports) {
        "use strict";
        exports.decode = exports.parse = require("./decode"), exports.encode = exports.stringify = require("./encode");

    }, {
        "./decode": 4,
        "./encode": 5
    }],
    7: [function(require, module, exports) {
        "use strict";

        function dq(t, e) {
            var n = [];
            return e = e || document, "function" == typeof t ? e.addEventListener("DOMContentLoaded", t) : n = t instanceof Element ? [t] : "string" == typeof t ? "<" === t[0] ? Array.prototype.slice.call(fragment(t)) : Array.prototype.slice.call(e.querySelectorAll(t)) : t, new DOMQuery(n, e)
        }

        function DOMQuery(t, e) {
            this.length = t.length, this.context = e;
            var n = this;
            each(t, function(t) {
                n[t] = this
            })
        }
        "function" != typeof Object.assign && (Object.assign = function(t, e) {
            if (null === t) throw new TypeError("Cannot convert undefined or null to object");
            for (var n = Object(t), r = 1; r < arguments.length; r++) {
                var o = arguments[r];
                if (null !== o)
                    for (var i in o) Object.prototype.hasOwnProperty.call(o, i) && (n[i] = o[i])
            }
            return n
        }), DOMQuery.prototype.each = function(t) {
            for (var e = this.length - 1; e >= 0; e--) t.call(this[e], e, this[e]);
            return this
        }, DOMQuery.prototype.empty = function() {
            return this.each(empty)
        }, DOMQuery.prototype.text = function(t) {
            return void 0 === t ? this[0].textContent : this.each(function() {
                this.textContent = t
            })
        }, DOMQuery.prototype.attr = function(t, e) {
            return this.length < 1 ? null : void 0 === e ? this[0].getAttribute(t) : this.each(function() {
                this.setAttribute(t, e)
            })
        }, DOMQuery.prototype.data = function(t, e) {
            if (e) return this.attr("data-" + t, e);
            if (t) return this.attr("data-" + t);
            var n = Object.assign({}, this[0].dataset);
            return each(n, function(t, e) {
                n[t] = deserializeValue(e)
            }), n
        }, DOMQuery.prototype.find = function(t) {
            var e;
            return e = map(this, function(e) {
                return e.querySelectorAll(t)
            }), e = map(e, function(t) {
                return Array.prototype.slice.call(t)
            }), e = Array.prototype.concat.apply([], e), new DOMQuery(e)
        }, DOMQuery.prototype.append = function(t) {
            return "string" == typeof t && (t = fragment(t)), append(this[0], t), this
        }, DOMQuery.prototype.prepend = function(t) {
            return "string" == typeof t && (t = fragment(t)), prepend(this[0], t), this
        }, DOMQuery.prototype.addClass = function(t) {
            return this.each(function() {
                this.classList.add(t)
            })
        }, DOMQuery.prototype.removeClass = function(t) {
            return this.each(function() {
                this.classList.remove(t)
            })
        }, DOMQuery.prototype.on = function(t, e, n) {
            return this.each(function() {
                delegateEvent(e, t, n, this)
            })
        };
        var empty = function() {
                for (; this.hasChildNodes();) this.removeChild(this.firstChild)
            },
            map = function(t, e) {
                return Array.prototype.map.call(t, e)
            },
            each = function(t, e) {
                if (t instanceof Array)
                    for (var n = 0; n < t.length; n++) e.call(t[n], n, t[n]);
                else if (t instanceof Object)
                    for (var r in t) e.call(t[r], r, t[r], t);
                return t
            },
            fragment = function(t) {
                var e = document.createElement("div");
                return e.innerHTML = t, e.children
            },
            append = function(t, e) {
                for (var n = 0; n < e.length; n++) t.appendChild(e[n])
            },
            prepend = function(t, e) {
                for (var n = e.length - 1; n >= 0; n--) t.insertBefore(e[e.length - 1], t.firstChild)
            },
            closest = function() {
                var t = HTMLElement.prototype,
                    e = t.matches || t.webkitMatchesSelector || t.mozMatchesSelector || t.msMatchesSelector;
                return function t(n, r) {
                    return e.call(n, r) ? n : t(n.parentElement, r)
                }
            }(),
            delegateEvent = function(t, e, n, r) {
                (r || document).addEventListener(e, function(e) {
                    var r = closest(e.target, t);
                    r && n.call(r, e)
                })
            },
            extend = function(t) {
                var e = {},
                    n = !1,
                    r = 0,
                    o = arguments.length;
                "[object Boolean]" === Object.prototype.toString.call(arguments[0]) && (n = arguments[0], r++);
                for (; r < o; r++) {
                    var i = arguments[r];
                    ! function(t) {
                        for (var r in t) Object.prototype.hasOwnProperty.call(t, r) && (n && "[object Object]" === Object.prototype.toString.call(t[r]) ? e[r] = extend(!0, e[r], t[r]) : e[r] = t[r])
                    }(i)
                }
                return e
            },
            getJSON = function(t, e) {
                var n = new XMLHttpRequest;
                n.open("GET", t, !0), n.setRequestHeader("Content-Type", "application/json"), n.setRequestHeader("Accept", "application/json"), n.onload = function() {
                    if (n.status >= 200 && n.status < 400) {
                        var t = JSON.parse(n.responseText);
                        e(!0, t, n)
                    } else e(!1, null, n)
                }, n.onerror = function() {
                    e(!1, null, n)
                }, n.send()
            },
            deserializeValue = function(t) {
                if ("true" === t) return !0;
                if ("false" === t) return !1;
                if ("null" === t) return null;
                if (+t + "" === t) return +t;
                if (/^[\[\{]/.test(t)) try {
                    return JSON.parse(t)
                } catch (e) {
                    return t
                }
                return t
            };
        dq.extend = extend, dq.map = map, dq.each = each, dq.getJSON = getJSON, module.exports = dq;
    }, {}],
    8: [function(require, module, exports) {
        "use strict";
        module.exports = function(d) {
            return {
                popup: !0,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "addthis",
                faName: "fa-plus",
                title: {
                    bg: "Сподели в AddThis",
                    da: "Del på AddThis",
                    de: "Bei AddThis teilen",
                    en: "Share on AddThis",
                    es: "Compartir en AddThis",
                    fi: "Jaa AddThisissä",
                    fr: "Partager sur AddThis",
                    hr: "Podijelite na AddThis",
                    hu: "Megosztás AddThisen",
                    it: "Condividi su AddThis",
                    ja: "AddThis上で共有",
                    ko: "AddThis에서 공유하기",
                    nl: "Delen op AddThis",
                    no: "Del på AddThis",
                    pl: "Udostępnij przez AddThis",
                    pt: "Compartilhar no AddThis",
                    ro: "Partajează pe AddThis",
                    ru: "Поделиться на AddThis",
                    sk: "Zdieľať na AddThis",
                    sl: "Deli na AddThis",
                    sr: "Podeli na AddThis",
                    sv: "Dela på AddThis",
                    tr: "AddThis'ta paylaş",
                    zh: "在AddThis上分享"
                },
                shareUrl: "http://api.addthis.com/oexchange/0.8/offer?url=" + encodeURIComponent(d.getURL()) + d.getReferrerTrack()
            }
        };

    }, {}],
    9: [function(require, module, exports) {
        "use strict";
        var url = require("url");
        module.exports = function(e) {
            var r = url.parse("https://share.diasporafoundation.org/", !0);
            return r.query.url = e.getURL(), r.query.title = e.getTitle() || e.getMeta("DC.title"), r.protocol = "https", delete r.search, {
                popup: !0,
                shareText: {
                    de: "teilen",
                    en: "share",
                    zh: "分享"
                },
                name: "diaspora",
                faName: "fa-asterisk",
                title: {
                    de: "Bei Diaspora teilen",
                    en: "Share on Diaspora",
                    zh: "分享至Diaspora"
                },
                shareUrl: url.format(r) + e.getReferrerTrack()
            }
        };

    }, {
        "url": 1
    }],
    10: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            return {
                popup: !0,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "facebook",
                faName: "fa-facebook",
                title: {
                    bg: "Сподели във Facebook",
                    da: "Del på Facebook",
                    de: "Bei Facebook teilen",
                    en: "Share on Facebook",
                    es: "Compartir en Facebook",
                    fi: "Jaa Facebookissa",
                    fr: "Partager sur Facebook",
                    hr: "Podijelite na Facebooku",
                    hu: "Megosztás Facebookon",
                    it: "Condividi su Facebook",
                    ja: "フェイスブック上で共有",
                    ko: "페이스북에서 공유하기",
                    nl: "Delen op Facebook",
                    no: "Del på Facebook",
                    pl: "Udostępnij na Facebooku",
                    pt: "Compartilhar no Facebook",
                    ro: "Partajează pe Facebook",
                    ru: "Поделиться на Facebook",
                    sk: "Zdieľať na Facebooku",
                    sl: "Deli na Facebooku",
                    sr: "Podeli na Facebook-u",
                    sv: "Dela på Facebook",
                    tr: "Facebook'ta paylaş",
                    zh: "在Facebook上分享"
                },
                shareUrl: "https://www.facebook.com/sharer/sharer.php?u=" + encodeURIComponent(e.getURL()) + e.getReferrerTrack()
            }
        };

    }, {}],
    11: [function(require, module, exports) {
        "use strict";
        module.exports = function(t) {
            var e = encodeURIComponent(t.getURL()),
                o = t.getMeta("DC.title"),
                r = t.getMeta("DC.creator"),
                n = t.getMeta("description");
            return o.length > 0 && r.length > 0 ? o += " - " + r : o = t.getTitle(), {
                popup: !0,
                shareText: "Flattr",
                name: "flattr",
                faName: "fa-money",
                title: {
                    de: "Artikel flattrn",
                    en: "Flattr this"
                },
                shareUrl: "https://flattr.com/submit/auto?title=" + encodeURIComponent(o) + "&description=" + encodeURIComponent(n) + "&category=" + encodeURIComponent(t.options.flattrCategory || "text") + "&user_id=" + encodeURIComponent(t.options.flattrUser) + "&url=" + e + t.getReferrerTrack()
            }
        };

    }, {}],
    12: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            return {
                popup: !0,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "googleplus",
                faName: "fa-google-plus",
                title: {
                    bg: "Сподели в Google+",
                    da: "Del på Google+",
                    de: "Bei Google+ teilen",
                    en: "Share on Google+",
                    es: "Compartir en Google+",
                    fi: "Jaa Google+:ssa",
                    fr: "Partager sur Goolge+",
                    hr: "Podijelite na Google+",
                    hu: "Megosztás Google+on",
                    it: "Condividi su Google+",
                    ja: "Google+上で共有",
                    ko: "Google+에서 공유하기",
                    nl: "Delen op Google+",
                    no: "Del på Google+",
                    pl: "Udostępnij na Google+",
                    pt: "Compartilhar no Google+",
                    ro: "Partajează pe Google+",
                    ru: "Поделиться на Google+",
                    sk: "Zdieľať na Google+",
                    sl: "Deli na Google+",
                    sr: "Podeli na Google+",
                    sv: "Dela på Google+",
                    tr: "Google+'da paylaş",
                    zh: "在Google+上分享"
                },
                shareUrl: "https://plus.google.com/share?url=" + encodeURIComponent(e.getURL()) + e.getReferrerTrack()
            }
        };

    }, {}],
    13: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            return {
                blank: !0,
                popup: !1,
                shareText: "Info",
                name: "info",
                faName: "fa-info",
                title: {
                    de: "weitere Informationen",
                    en: "more information",
                    es: "más informaciones",
                    fr: "plus d'informations",
                    it: "maggiori informazioni",
                    da: "flere oplysninger",
                    nl: "verdere informatie",
                    zh: "更多信息"
                },
                shareUrl: e.getInfoUrl()
            }
        };

    }, {}],
    14: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            var n = encodeURIComponent(e.getURL()),
                i = encodeURIComponent(e.getTitle());
            return {
                popup: !0,
                shareText: {
                    de: "mitteilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "シェア",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "distribuiți",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "linkedin",
                faName: "fa-linkedin",
                title: {
                    bg: "Сподели в LinkedIn",
                    da: "Del på LinkedIn",
                    de: "Bei LinkedIn teilen",
                    en: "Share on LinkedIn",
                    es: "Compartir en LinkedIn",
                    fi: "Jaa LinkedInissä",
                    fr: "Partager sur LinkedIn",
                    hr: "Podijelite na LinkedIn",
                    hu: "Megosztás LinkedInen",
                    it: "Condividi su LinkedIn",
                    ja: "LinkedIn上で共有",
                    ko: "LinkedIn에서 공유하기",
                    nl: "Delen op LinkedIn",
                    no: "Del på LinkedIn",
                    pl: "Udostępnij przez LinkedIn",
                    pt: "Compartilhar no LinkedIn",
                    ro: "Partajează pe LinkedIn",
                    ru: "Поделиться на LinkedIn",
                    sk: "Zdieľať na LinkedIn",
                    sl: "Deli na LinkedIn",
                    sr: "Podeli na LinkedIn-u",
                    sv: "Dela på LinkedIn",
                    tr: "LinkedIn'ta paylaş",
                    zh: "在LinkedIn上分享"
                },
                shareUrl: "https://www.linkedin.com/shareArticle?mini=true&summary=" + encodeURIComponent(e.getMeta("description")) + "&title=" + i + "&url=" + n
            }
        };

    }, {}],
    15: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            var i = e.getOption("mailUrl");
            return 0 === i.indexOf("mailto:") && (i += "?subject=" + encodeURIComponent(e.getOption("mailSubject")), i += "&body=" + encodeURIComponent(e.getOption("mailBody"))), {
                blank: 0 === i.indexOf("http"),
                popup: !1,
                shareText: {
                    en: "mail",
                    zh: "分享"
                },
                name: "mail",
                faName: "fa-envelope",
                title: {
                    bg: "Изпрати по имейл",
                    da: "Sende via e-mail",
                    de: "Per E-Mail versenden",
                    en: "Send by email",
                    es: "Enviar por email",
                    fi: "Lähetä sähköpostitse",
                    fr: "Envoyer par courriel",
                    hr: "Pošaljite emailom",
                    hu: "Elküldés e-mailben",
                    it: "Inviare via email",
                    ja: "電子メールで送信",
                    ko: "이메일로 보내기",
                    nl: "Sturen via e-mail",
                    no: "Send via epost",
                    pl: "Wyślij e-mailem",
                    pt: "Enviar por e-mail",
                    ro: "Trimite prin e-mail",
                    ru: "Отправить по эл. почте",
                    sk: "Poslať e-mailom",
                    sl: "Pošlji po elektronski pošti",
                    sr: "Pošalji putem email-a",
                    sv: "Skicka via e-post",
                    tr: "E-posta ile gönder",
                    zh: "通过电子邮件传送"
                },
                shareUrl: i
            }
        };

    }, {}],
    16: [function(require, module, exports) {
        "use strict";
        var url = require("url");
        module.exports = function(e) {
            var t = e.getMeta("DC.title") || e.getTitle(),
                r = e.getMeta("DC.creator");
            r.length > 0 && (t += " - " + r);
            var i = e.getOption("mediaUrl");
            (!i || i.length <= 0) && (i = e.getMeta("og:image"));
            var n = url.parse("https://www.pinterest.com/pin/create/link/", !0);
            return n.query.url = e.getURL(), n.query.media = i, n.query.description = t, delete n.search, {
                popup: !0,
                shareText: "pin it",
                name: "pinterest",
                faName: "fa-pinterest-p",
                title: {
                    de: "Bei Pinterest pinnen",
                    en: "Pin it on Pinterest",
                    es: "Compartir en Pinterest",
                    fr: "Partager sur Pinterest",
                    it: "Condividi su Pinterest",
                    da: "Del på Pinterest",
                    nl: "Delen op Pinterest",
                    zh: "分享至Pinterest"
                },
                shareUrl: url.format(n) + e.getReferrerTrack()
            }
        };

    }, {
        "url": 1
    }],
    17: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            var t = encodeURIComponent(e.getURL()),
                r = e.getMeta("DC.title"),
                a = e.getMeta("DC.creator");
            return r.length > 0 && a.length > 0 ? r += " - " + a : r = e.getTitle(), {
                popup: !0,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "qzone",
                faName: "fa-qq",
                title: {
                    de: "Bei Qzone teilen",
                    en: "Share on Qzone",
                    zh: "分享至QQ空间"
                },
                shareUrl: "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url=" + t + "&title=" + r + e.getReferrerTrack()
            }
        };

    }, {}],
    18: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            var t = encodeURIComponent(e.getURL()),
                r = encodeURIComponent(e.getTitle());
            return "" !== r && (r = "&title=" + r), {
                popup: !0,
                shareText: {
                    de: "teilen",
                    en: "share",
                    zh: "分享"
                },
                name: "reddit",
                faName: "fa-reddit",
                title: {
                    de: "Bei Reddit teilen",
                    en: "Share on Reddit",
                    zh: "分享至Reddit"
                },
                shareUrl: "https://reddit.com/submit?url=" + t + r + e.getReferrerTrack()
            }
        };

    }, {}],
    19: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            var t = encodeURIComponent(e.getURL()),
                n = encodeURIComponent(e.getTitle());
            return "" !== n && (n = "&title=" + n), {
                popup: !0,
                shareText: {
                    de: "teilen",
                    en: "share",
                    zh: "分享"
                },
                name: "stumbleupon",
                faName: "fa-stumbleupon",
                title: {
                    de: "Bei Stumbleupon teilen",
                    en: "Share on Stumbleupon",
                    zh: "分享至Stumbleupon"
                },
                shareUrl: "https://www.stumbleupon.com/submit?url=" + t + n + e.getReferrerTrack()
            }
        };

    }, {}],
    20: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            var t = encodeURIComponent(e.getURL()),
                r = e.getMeta("DC.title"),
                a = e.getMeta("DC.creator");
            return r.length > 0 && a.length > 0 ? r += " - " + a : r = e.getTitle(), {
                popup: !0,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "tencent-weibo",
                faName: "fa-tencent-weibo",
                title: {
                    de: "Bei tencent weibo teilen",
                    en: "Share on tencent weibo",
                    zh: "分享至腾讯微博"
                },
                shareUrl: "http://v.t.qq.com/share/share.php?url=" + t + "&title=" + r + e.getReferrerTrack()
            }
        };

    }, {}],
    21: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            var a = encodeURIComponent(e.getURL()),
                r = e.getMeta("DC.title"),
                t = e.getMeta("DC.creator");
            return r.length > 0 && t.length > 0 ? r += " - " + t : r = e.getTitle(), {
                popup: !1,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "threema",
                faName: "fa-lock",
                title: {
                    bg: "Сподели в Threema",
                    da: "Del på Threema",
                    de: "Bei Threema teilen",
                    en: "Share on Threema",
                    es: "Compartir en Threema",
                    fi: "Jaa Threemaissä",
                    fr: "Partager sur Threema",
                    hr: "Podijelite na Threema",
                    hu: "Megosztás Threemaen",
                    it: "Condividi su Threema",
                    ja: "Threema上で共有",
                    ko: "Threema에서 공유하기",
                    nl: "Delen op Threema",
                    no: "Del på Threema",
                    pl: "Udostępnij przez Threema",
                    pt: "Compartilhar no Threema",
                    ro: "Partajează pe Threema",
                    ru: "Поделиться на Threema",
                    sk: "Zdieľať na Threema",
                    sl: "Deli na Threema",
                    sr: "Podeli na Threema-u",
                    sv: "Dela på Threema",
                    tr: "Threema'ta paylaş",
                    zh: "在Threema上分享"
                },
                shareUrl: "threema://compose?text=" + encodeURIComponent(r) + "%20" + a + e.getReferrerTrack()
            }
        };

    }, {}],
    22: [function(require, module, exports) {
        "use strict";
        module.exports = function(t) {
            var e = encodeURIComponent(t.getURL()),
                r = t.getMeta("DC.title"),
                l = t.getMeta("DC.creator");
            return r.length > 0 && l.length > 0 ? r += " - " + l : r = t.getTitle(), {
                popup: !0,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "tumblr",
                faName: "fa-tumblr",
                title: {
                    bg: "Сподели в tumblr",
                    da: "Del på tumblr",
                    de: "Bei tumblr teilen",
                    en: "Share on tumblr",
                    es: "Compartir en tumblr",
                    fi: "Jaa tumblrissä",
                    fr: "Partager sur tumblr",
                    hr: "Podijelite na tumblr",
                    hu: "Megosztás tumblren",
                    it: "Condividi su tumblr",
                    ja: "tumblr上で共有",
                    ko: "tumblr에서 공유하기",
                    nl: "Delen op tumblr",
                    no: "Del på tumblr",
                    pl: "Udostępnij przez tumblr",
                    pt: "Compartilhar no tumblr",
                    ro: "Partajează pe tumblr",
                    ru: "Поделиться на tumblr",
                    sk: "Zdieľať na tumblr",
                    sl: "Deli na tumblr",
                    sr: "Podeli na tumblr-u",
                    sv: "Dela på tumblr",
                    tr: "tumblr'ta paylaş",
                    zh: "在tumblr上分享"
                },
                shareUrl: "http://tumblr.com/widgets/share/tool?canonicalUrl=" + e + t.getReferrerTrack()
            }
        };

    }, {}],
    23: [function(require, module, exports) {
        "use strict";
        var url = require("url"),
            abbreviateText = function(t, e) {
                var r = document.createElement("div");
                r.innerHTML = t;
                var i = r.textContent;
                if (i.length <= e) return t;
                var a = i.substring(0, e - 1).lastIndexOf(" ");
                return i = i.substring(0, a) + "…"
            };
        module.exports = function(t) {
            var e = url.parse("https://twitter.com/intent/tweet", !0),
                r = t.getMeta("DC.title"),
                i = t.getMeta("DC.creator");
            return r.length > 0 && i.length > 0 ? r += " - " + i : r = t.getTitle(), e.query.text = abbreviateText(r, 120), e.query.url = t.getURL(), null !== t.options.twitterVia && (e.query.via = t.options.twitterVia), delete e.search, {
                popup: !0,
                shareText: {
                    en: "tweet",
                    zh: "分享"
                },
                name: "twitter",
                faName: "fa-twitter",
                title: {
                    bg: "Сподели в Twitter",
                    da: "Del på Twitter",
                    de: "Bei Twitter teilen",
                    en: "Share on Twitter",
                    es: "Compartir en Twitter",
                    fi: "Jaa Twitterissä",
                    fr: "Partager sur Twitter",
                    hr: "Podijelite na Twitteru",
                    hu: "Megosztás Twitteren",
                    it: "Condividi su Twitter",
                    ja: "ツイッター上で共有",
                    ko: "트위터에서 공유하기",
                    nl: "Delen op Twitter",
                    no: "Del på Twitter",
                    pl: "Udostępnij na Twitterze",
                    pt: "Compartilhar no Twitter",
                    ro: "Partajează pe Twitter",
                    ru: "Поделиться на Twitter",
                    sk: "Zdieľať na Twitteri",
                    sl: "Deli na Twitterju",
                    sr: "Podeli na Twitter-u",
                    sv: "Dela på Twitter",
                    tr: "Twitter'da paylaş",
                    zh: "在Twitter上分享"
                },
                shareUrl: url.format(e) + t.getReferrerTrack()
            }
        };

    }, {
        "url": 1
    }],
    24: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            var t = encodeURIComponent(e.getURL()),
                r = e.getMeta("DC.title"),
                a = e.getMeta("DC.creator");
            return r.length > 0 && a.length > 0 ? r += " - " + a : r = e.getTitle(), {
                popup: !0,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "weibo",
                faName: "fa-weibo",
                title: {
                    de: "Bei weibo teilen",
                    en: "Share on weibo",
                    zh: "分享至新浪微博"
                },
                shareUrl: "http://service.weibo.com/share/share.php?url=" + t + "&title=" + r + e.getReferrerTrack()
            }
        };

    }, {}],
    25: [function(require, module, exports) {
        "use strict";
        module.exports = function(a) {
            var p = encodeURIComponent(a.getURL()),
                e = a.getMeta("DC.title"),
                t = a.getMeta("DC.creator");
            return e.length > 0 && t.length > 0 ? e += " - " + t : e = a.getTitle(), {
                popup: !1,
                shareText: {
                    bg: "cподеляне",
                    da: "del",
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fi: "Jaa",
                    fr: "partager",
                    hr: "podijelite",
                    hu: "megosztás",
                    it: "condividi",
                    ja: "共有",
                    ko: "공유하기",
                    nl: "delen",
                    no: "del",
                    pl: "udostępnij",
                    pt: "compartilhar",
                    ro: "partajează",
                    ru: "поделиться",
                    sk: "zdieľať",
                    sl: "deli",
                    sr: "podeli",
                    sv: "dela",
                    tr: "paylaş",
                    zh: "分享"
                },
                name: "whatsapp",
                faName: "fa-whatsapp",
                title: {
                    bg: "Сподели в Whatsapp",
                    da: "Del på Whatsapp",
                    de: "Bei Whatsapp teilen",
                    en: "Share on Whatsapp",
                    es: "Compartir en Whatsapp",
                    fi: "Jaa WhatsAppissä",
                    fr: "Partager sur Whatsapp",
                    hr: "Podijelite na Whatsapp",
                    hu: "Megosztás WhatsAppen",
                    it: "Condividi su Whatsapp",
                    ja: "Whatsapp上で共有",
                    ko: "Whatsapp에서 공유하기",
                    nl: "Delen op Whatsapp",
                    no: "Del på Whatsapp",
                    pl: "Udostępnij przez WhatsApp",
                    pt: "Compartilhar no Whatsapp",
                    ro: "Partajează pe Whatsapp",
                    ru: "Поделиться на Whatsapp",
                    sk: "Zdieľať na Whatsapp",
                    sl: "Deli na Whatsapp",
                    sr: "Podeli na WhatsApp-u",
                    sv: "Dela på Whatsapp",
                    tr: "Whatsapp'ta paylaş",
                    zh: "在Whatsapp上分享"
                },
                shareUrl: "whatsapp://send?text=" + encodeURIComponent(e) + "%20" + p + a.getReferrerTrack()
            }
        };

    }, {}],
    26: [function(require, module, exports) {
        "use strict";
        module.exports = function(e) {
            return {
                popup: !0,
                shareText: {
                    de: "teilen",
                    en: "share",
                    es: "compartir",
                    fr: "partager",
                    it: "condividi",
                    da: "del",
                    nl: "delen",
                    zh: "分享"
                },
                name: "xing",
                faName: "fa-xing",
                title: {
                    de: "Bei XING teilen",
                    en: "Share on XING",
                    es: "Compartir en XING",
                    fr: "Partager sur XING",
                    it: "Condividi su XING",
                    da: "Del på XING",
                    nl: "Delen op XING",
                    zh: "分享至XING"
                },
                shareUrl: "https://www.xing.com/social_plugins/share?url=" + encodeURIComponent(e.getURL()) + e.getReferrerTrack()
            }
        };

    }, {}],
    27: [function(require, module, exports) {
        (function(global) {
            "use strict";
            var $ = require("./dom"),
                url = require("url"),
                Shariff = function(e, t) {
                    var r = this;
                    this.element = e, $(e).empty(), this.options = $.extend({}, this.defaults, t, $(e).data());
                    var i = [require("./services/addthis"), require("./services/diaspora"), require("./services/facebook"), require("./services/flattr"), require("./services/googleplus"), require("./services/info"), require("./services/linkedin"), require("./services/mail"), require("./services/pinterest"), require("./services/reddit"), require("./services/stumbleupon"), require("./services/twitter"), require("./services/whatsapp"), require("./services/xing"), require("./services/tumblr"), require("./services/threema"), require("./services/weibo"), require("./services/tencent-weibo"), require("./services/qzone")];
                    this.services = $.map(this.options.services, function(e) {
                        var t = null;
                        return i.forEach(function(i) {
                            if (i = i(r), i.name === e) return t = i, null
                        }), t
                    }), this._addButtonList(), null !== this.options.backendUrl && this.getShares(this._updateCounts.bind(this))
                };
            Shariff.prototype = {
                defaults: {
					theme: "project", // variablen: color | project | grey 
                    backendUrl: null,
                    infoUrl: shariff_link,
                    lang: "de",
                    langFallback: "en",
                    mailUrl: function() {
                        var e = url.parse(this.getURL(), !0);
                        return e.query.view = "mail", delete e.search, url.format(e)
                    },
                    mailSubject: function() {
                        return this.getMeta("DC.title") || this.getTitle()
                    },
                    mailBody: function() {
                        return this.getURL()
                    },
                    mediaUrl: null,
					orientation: "horizontal",
					buttonstyle: "icon",
                    referrerTrack: null,
                    services: schariff_socials,
                    title: function() {
                        return $("head title").text()
                    },
                    twitterVia: null,
                    flattrUser: null,
                    flattrCategory: null,
                    url: function() {
                        var e = global.document.location.href,
                            t = $("link[rel=canonical]").attr("href") || this.getMeta("og:url") || "";
                        return t.length > 0 && (t.indexOf("http") < 0 && (t = global.document.location.protocol + "//" + global.document.location.host + t), e = t), e
                    }
                },
                $socialshareElement: function() {
                    return $(this.element)
                },
                getLocalized: function(e, t) {
                    return "object" == typeof e[t] ? void 0 === e[t][this.options.lang] ? e[t][this.options.langFallback] : e[t][this.options.lang] : "string" == typeof e[t] ? e[t] : void 0
                },
                getMeta: function(e) {
                    return $('meta[name="' + e + '"],[property="' + e + '"]').attr("content") || ""
                },
                getInfoUrl: function() {
                    return this.options.infoUrl
                },
                getURL: function() {
                    return this.getOption("url")
                },
                getOption: function(e) {
                    var t = this.options[e];
                    return "function" == typeof t ? t.call(this) : t
                },
                getTitle: function() {
                    return this.getOption("title")
                },
                getReferrerTrack: function() {
                    return this.options.referrerTrack || ""
                },
                getShares: function(e) {
                    var t = url.parse(this.options.backendUrl, !0);
                    return t.query.url = this.getURL(), delete t.search, $.getJSON(url.format(t), e)
                },
                _updateCounts: function(e, t) {
                    var r = this;
                    $.each(t, function(e, t) {
                        t >= 1e3 && (t = Math.round(t / 1e3) + "k"), $(r.element).find("." + e + " a").append('&nbsp;<span class="share_count">' + t)
                    })
                },
                _addButtonList: function() {
                    var e = this,
                        t = this.$socialshareElement(),
                        r = "theme-" + this.options.theme,
                        i = "orientation-" + this.options.orientation,
                        n = "col-" + this.options.services.length,
                        x = "button-style-" + this.options.buttonstyle,
                        a = $("<ul>").addClass(r).addClass(i).addClass(n).addClass(x);

                    this.services.forEach(function(t) {
                        var r = $('<li class="shariff-button ">').addClass(t.name),
                            i = '<span class="share_text">' + e.getLocalized(t, "shareText"),
                            n = $("<a>").attr("href", t.shareUrl).append(i);
						void 0 !== t.faName && n.prepend('<span class="fa icon ' + t.name + ' ' + t.faName + '">'), t.popup ? n.attr("data-rel", "popup") : t.blank && n.attr("target", "_blank"), n.attr("title", e.getLocalized(t, "title")), n.attr("role", "button"), n.attr("aria-label", e.getLocalized(t, "title")), r.append(n), a.append(r)
                    }), a.on("click", '[data-rel="popup"]', function(e) {
                        e.preventDefault();
                        var t = $(this).attr("href");

                        _setOverlayForAccept(t,global);
                        
                        

                    }), t.append(a)
                }
            }, module.exports = Shariff, global.Shariff = Shariff, $(function() {
                $(".shariff").each(function() {
                    this.hasOwnProperty("shariff") || (this.shariff = new Shariff(this))
                })
            });
        }).call(this, typeof global !== "undefined" ? global : typeof self !== "undefined" ? self : typeof window !== "undefined" ? window : {})
    }, {
        "./dom": 7,
        "./services/addthis": 8,
        "./services/diaspora": 9,
        "./services/facebook": 10,
        "./services/flattr": 11,
        "./services/googleplus": 12,
        "./services/info": 13,
        "./services/linkedin": 14,
        "./services/mail": 15,
        "./services/pinterest": 16,
        "./services/qzone": 17,
        "./services/reddit": 18,
        "./services/stumbleupon": 19,
        "./services/tencent-weibo": 20,
        "./services/threema": 21,
        "./services/tumblr": 22,
        "./services/twitter": 23,
        "./services/weibo": 24,
        "./services/whatsapp": 25,
        "./services/xing": 26,
        "url": 1
    }]
}, {}, [27]);
