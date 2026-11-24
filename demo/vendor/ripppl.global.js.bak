function MB(e) {
  return e && e.__esModule && Object.prototype.hasOwnProperty.call(e, "default") ? e.default : e;
}
var St = { exports: {} };
/*! dom-to-image-more 23-10-2025 */
var OB = St.exports, mn;
function RB() {
  return mn || (mn = 1, (function(e, A) {
    ((r) => {
      let t = /* @__PURE__ */ (() => {
        let Q = 0;
        return { escape: function(u) {
          return u.replace(/([.*+?^${}()|[\]/\\])/g, "\\$1");
        }, isDataUrl: function(u) {
          return u.search(/^(data:)/) !== -1;
        }, canvasToBlob: function(u) {
          return u.toBlob ? new Promise(function(U) {
            u.toBlob(U);
          }) : ((U) => new Promise(function(x) {
            var p = H(U.toDataURL().split(",")[1]), T = p.length, X = new Uint8Array(T);
            for (let z = 0; z < T; z++) X[z] = p.charCodeAt(z);
            x(new Blob([X], { type: "image/png" }));
          }))(u);
        }, resolveUrl: function(u, U) {
          var x = document.implementation.createHTMLDocument(), p = x.createElement("base"), T = (x.head.appendChild(p), x.createElement("a"));
          return x.body.appendChild(T), p.href = U, T.href = u, T.href;
        }, getAndEncode: function(u) {
          let U = o.impl.urlCache.find(function(x) {
            return x.url === u;
          });
          return U || (U = { url: u, promise: null }, o.impl.urlCache.push(U)), U.promise === null && (o.impl.options.cacheBust && (u += (/\?/.test(u) ? "&" : "?") + (/* @__PURE__ */ new Date()).getTime()), U.promise = new Promise(function(x) {
            let p = new XMLHttpRequest();
            function T(S) {
              console.error(S), x("");
            }
            function X() {
              var S = o.impl.options.imagePlaceholder;
              S ? x(S) : T("Status:" + p.status + " while fetching resource: " + u);
            }
            if (p.timeout = o.impl.options.httpTimeout, p.onerror = X, p.ontimeout = X, p.onloadend = function() {
              if (p.readyState === XMLHttpRequest.DONE) {
                var S = p.status;
                if (S === 0 && u.toLowerCase().startsWith("file://") || 200 <= S && S <= 300 && p.response !== null) {
                  S = p.response, S instanceof Blob || T("Expected response to be a Blob, but got: " + typeof S);
                  let k = new FileReader();
                  k.onloadend = function() {
                    var G = k.result;
                    x(G);
                  };
                  try {
                    k.readAsDataURL(S);
                  } catch (G) {
                    T("Failed to read the response as Data URL: " + G.toString());
                  }
                } else X();
              }
            }, 0 < o.impl.options.useCredentialsFilters.length && (o.impl.options.useCredentials = 0 < o.impl.options.useCredentialsFilters.filter((S) => 0 <= u.search(S)).length), o.impl.options.useCredentials && (p.withCredentials = !0), o.impl.options.corsImg && u.indexOf("http") === 0 && u.indexOf(window.location.origin) === -1) {
              var z = (o.impl.options.corsImg.method || "GET").toUpperCase() === "POST" ? "POST" : "GET";
              p.open(z, (o.impl.options.corsImg.url || "").replace("#{cors}", u), !0);
              let S = !1, k = o.impl.options.corsImg.headers || {}, G = (Object.keys(k).forEach(function(E) {
                k[E].indexOf("application/json") !== -1 && (S = !0), p.setRequestHeader(E, k[E]);
              }), ((E) => {
                try {
                  return JSON.parse(JSON.stringify(E));
                } catch (_) {
                  T("corsImg.data is missing or invalid:" + _.toString());
                }
              })(o.impl.options.corsImg.data || ""));
              Object.keys(G).forEach(function(E) {
                typeof G[E] == "string" && (G[E] = G[E].replace("#{cors}", u));
              }), p.responseType = "blob", p.send(S ? JSON.stringify(G) : G);
            } else p.open("GET", u, !0), p.responseType = "blob", p.send();
          })), U.promise;
        }, uid: function() {
          return "u" + ("0000" + (Math.random() * Math.pow(36, 4) << 0).toString(36)).slice(-4) + Q++;
        }, asArray: function(u) {
          var U = [], x = u.length;
          for (let p = 0; p < x; p++) U.push(u[p]);
          return U;
        }, escapeXhtml: function(u) {
          return u.replace(/%/g, "%25").replace(/#/g, "%23").replace(/\n/g, "%0A");
        }, makeImage: function(u) {
          return u !== "data:," ? new Promise(function(U, x) {
            let p = document.createElementNS("http://www.w3.org/2000/svg", "svg"), T = new Image();
            o.impl.options.useCredentials && (T.crossOrigin = "use-credentials"), T.onload = function() {
              document.body.removeChild(p), window && window.requestAnimationFrame ? window.requestAnimationFrame(function() {
                U(T);
              }) : U(T);
            }, T.onerror = (X) => {
              document.body.removeChild(p), x(X);
            }, p.appendChild(T), T.src = u, document.body.appendChild(p);
          }) : Promise.resolve();
        }, width: function(u) {
          var U = I(u, "width");
          if (!isNaN(U)) return U;
          var U = I(u, "border-left-width"), x = I(u, "border-right-width");
          return u.scrollWidth + U + x;
        }, height: function(u) {
          var U = I(u, "height");
          if (!isNaN(U)) return U;
          var U = I(u, "border-top-width"), x = I(u, "border-bottom-width");
          return u.scrollHeight + U + x;
        }, getWindow: l, isElement: R, isElementHostForOpenShadowRoot: function(u) {
          return R(u) && u.shadowRoot !== null;
        }, isShadowRoot: C, isInShadowRoot: m, isHTMLElement: function(u) {
          return u instanceof l(u).HTMLElement;
        }, isHTMLCanvasElement: function(u) {
          return u instanceof l(u).HTMLCanvasElement;
        }, isHTMLInputElement: function(u) {
          return u instanceof l(u).HTMLInputElement;
        }, isHTMLImageElement: function(u) {
          return u instanceof l(u).HTMLImageElement;
        }, isHTMLLinkElement: function(u) {
          return u instanceof l(u).HTMLLinkElement;
        }, isHTMLScriptElement: function(u) {
          return u instanceof l(u).HTMLScriptElement;
        }, isHTMLStyleElement: function(u) {
          return u instanceof l(u).HTMLStyleElement;
        }, isHTMLTextAreaElement: function(u) {
          return u instanceof l(u).HTMLTextAreaElement;
        }, isShadowSlotElement: function(u) {
          return m(u) && u instanceof l(u).HTMLSlotElement;
        }, isSVGElement: function(u) {
          return u instanceof l(u).SVGElement;
        }, isSVGRectElement: function(u) {
          return u instanceof l(u).SVGRectElement;
        }, isDimensionMissing: function(u) {
          return isNaN(u) || u <= 0;
        } };
        function l(u) {
          return u = u ? u.ownerDocument : void 0, (u ? u.defaultView : void 0) || window || r;
        }
        function C(u) {
          return u instanceof l(u).ShadowRoot;
        }
        function m(u) {
          return u != null && u.getRootNode !== void 0 && C(u.getRootNode());
        }
        function R(u) {
          return u instanceof l(u).Element;
        }
        function I(u, U) {
          if (u.nodeType === g) {
            let x = f(u).getPropertyValue(U);
            if (x.slice(-2) === "px") return x = x.slice(0, -2), parseFloat(x);
          }
          return NaN;
        }
      })(), n = /* @__PURE__ */ (() => {
        let Q = /url\(\s*(["']?)((?:\\.|[^\\)])+)\1\s*\)/gm;
        return { inlineAll: function(I, u, U) {
          return l(I) ? Promise.resolve(I).then(C).then(function(x) {
            let p = Promise.resolve(I);
            return x.forEach(function(T) {
              p = p.then(function(X) {
                return R(X, T, u, U);
              });
            }), p;
          }) : Promise.resolve(I);
        }, shouldProcess: l, impl: { readUrls: C, inline: R, urlAsRegex: m } };
        function l(I) {
          return I.search(Q) !== -1;
        }
        function C(I) {
          for (var u, U = []; (u = Q.exec(I)) !== null; ) U.push(u[2]);
          return U.filter(function(x) {
            return !t.isDataUrl(x);
          });
        }
        function m(I) {
          return new RegExp(`url\\((["']?)(${t.escape(I)})\\1\\)`, "gm");
        }
        function R(I, u, U, x) {
          return Promise.resolve(u).then(function(p) {
            return U ? t.resolveUrl(p, U) : p;
          }).then(x || t.getAndEncode).then(function(p) {
            var T = m(u);
            return I.replace(T, `url($1${p}$1)`);
          });
        }
      })(), s = { resolveAll: function() {
        return B().then(function(Q) {
          return Promise.all(Q.map(function(l) {
            return l.resolve();
          }));
        }).then(function(Q) {
          return Q.join(`
`);
        });
      }, impl: { readAll: B } };
      function B() {
        return Promise.resolve(t.asArray(document.styleSheets)).then(function(l) {
          let C = [];
          return l.forEach(function(m) {
            var R = Object.getPrototypeOf(m);
            if (Object.prototype.hasOwnProperty.call(R, "cssRules")) try {
              t.asArray(m.cssRules || []).forEach(C.push.bind(C));
            } catch (I) {
              console.error("domtoimage: Error while reading CSS rules from: " + m.href, I.toString());
            }
          }), C;
        }).then(function(l) {
          return l.filter(function(C) {
            return C.type === CSSRule.FONT_FACE_RULE;
          }).filter(function(C) {
            return n.shouldProcess(C.style.getPropertyValue("src"));
          });
        }).then(function(l) {
          return l.map(Q);
        });
        function Q(l) {
          return { resolve: function() {
            var C = (l.parentStyleSheet || {}).href;
            return n.inlineAll(l.cssText, C);
          }, src: function() {
            return l.style.getPropertyValue("src");
          } };
        }
      }
      let i = { inlineAll: function Q(l) {
        if (!t.isElement(l)) return Promise.resolve(l);
        return C(l).then(function() {
          return t.isHTMLImageElement(l) ? a(l).inline() : Promise.all(t.asArray(l.childNodes).map(function(m) {
            return Q(m);
          }));
        });
        function C(m) {
          let R = ["background", "background-image"], I = R.map(function(u) {
            let U = m.style.getPropertyValue(u), x = m.style.getPropertyPriority(u);
            return U ? n.inlineAll(U).then(function(p) {
              m.style.setProperty(u, p, x);
            }) : Promise.resolve();
          });
          return Promise.all(I).then(function() {
            return m;
          });
        }
      }, impl: { newImage: a } };
      function a(Q) {
        return { inline: function(l) {
          return t.isDataUrl(Q.src) ? Promise.resolve() : Promise.resolve(Q.src).then(l || t.getAndEncode).then(function(C) {
            return new Promise(function(m) {
              Q.onload = m, Q.onerror = m, Q.src = C;
            });
          });
        } };
      }
      let c = { copyDefaultStyles: !0, imagePlaceholder: void 0, cacheBust: !1, useCredentials: !1, useCredentialsFilters: [], httpTimeout: 3e4, styleCaching: "strict", corsImg: void 0 }, o = { toSvg: w, toPng: function(Q, l) {
        return F(Q, l).then(function(C) {
          return C.toDataURL();
        });
      }, toJpeg: function(Q, l) {
        return F(Q, l).then(function(C) {
          return C.toDataURL("image/jpeg", (l ? l.quality : void 0) || 1);
        });
      }, toBlob: function(Q, l) {
        return F(Q, l).then(t.canvasToBlob);
      }, toPixelData: function(Q, l) {
        return F(Q, l).then(function(C) {
          return C.getContext("2d").getImageData(0, 0, t.width(Q), t.height(Q)).data;
        });
      }, toCanvas: F, impl: { fontFaces: s, images: i, util: t, inliner: n, urlCache: [], options: {}, copyOptions: function(Q) {
        Q.copyDefaultStyles === void 0 ? o.impl.options.copyDefaultStyles = c.copyDefaultStyles : o.impl.options.copyDefaultStyles = Q.copyDefaultStyles, o.impl.options.imagePlaceholder = (Q.imagePlaceholder === void 0 ? c : Q).imagePlaceholder, o.impl.options.cacheBust = (Q.cacheBust === void 0 ? c : Q).cacheBust, o.impl.options.corsImg = (Q.corsImg === void 0 ? c : Q).corsImg, o.impl.options.useCredentials = (Q.useCredentials === void 0 ? c : Q).useCredentials, o.impl.options.useCredentialsFilters = (Q.useCredentialsFilters === void 0 ? c : Q).useCredentialsFilters, o.impl.options.httpTimeout = (Q.httpTimeout === void 0 ? c : Q).httpTimeout, o.impl.options.styleCaching = (Q.styleCaching === void 0 ? c : Q).styleCaching;
      } } }, g = (e.exports = o, (Node === void 0 ? void 0 : Node.ELEMENT_NODE) || 1), f = (r === void 0 ? void 0 : r.getComputedStyle) || (window === void 0 ? void 0 : window.getComputedStyle) || globalThis.getComputedStyle, H = (r === void 0 ? void 0 : r.atob) || (window === void 0 ? void 0 : window.atob) || globalThis.atob;
      function w(Q, l) {
        o.impl.util.getWindow(Q);
        let C = (l = l || {}, o.impl.copyOptions(l), []);
        return Promise.resolve(Q).then(function(m) {
          if (m.nodeType === g) return m;
          var R = m, I = document.createElement("span");
          return R.replaceWith(I), I.append(m), C.push({ child: R, wrapper: I }), I;
        }).then(function(m) {
          return (function R(I, u, U, x) {
            let p = u.filter;
            if (I === b || t.isHTMLScriptElement(I) || t.isHTMLStyleElement(I) || t.isHTMLLinkElement(I) || U !== null && p && !p(I)) return Promise.resolve();
            return Promise.resolve(I).then(T).then(X).then(function(E) {
              return k(E, S(I));
            }).then(z).then(function(E) {
              return G(E, I);
            });
            function T(E) {
              return t.isHTMLCanvasElement(E) ? t.makeImage(E.toDataURL()) : E.cloneNode(!1);
            }
            function X(E) {
              return u.adjustClonedNode && u.adjustClonedNode(I, E, !1), Promise.resolve(E);
            }
            function z(E) {
              return u.adjustClonedNode && u.adjustClonedNode(I, E, !0), Promise.resolve(E);
            }
            function S(E) {
              return t.isElementHostForOpenShadowRoot(E) ? E.shadowRoot : E;
            }
            function k(E, _) {
              let BA = OA(_), uA = Promise.resolve();
              if (BA.length !== 0) {
                let gA = f(wA(_));
                t.asArray(BA).forEach(function(CA) {
                  uA = uA.then(function() {
                    return R(CA, u, gA).then(function(xA) {
                      xA && E.appendChild(xA);
                    });
                  });
                });
              }
              return uA.then(function() {
                return E;
              });
              function wA(gA) {
                return t.isShadowRoot(gA) ? gA.host : gA;
              }
              function OA(gA) {
                if (t.isShadowSlotElement(gA)) {
                  let CA = gA.assignedNodes();
                  if (CA && 0 < CA.length) return CA;
                }
                return gA.childNodes;
              }
            }
            function G(E, _) {
              return !t.isElement(E) || t.isShadowSlotElement(_) ? Promise.resolve(E) : Promise.resolve().then(uA).then(wA).then(OA).then(gA).then(BA).then(function() {
                return E;
              });
              function BA() {
                t.isHTMLImageElement(E) && (E.removeAttribute("loading"), _.srcset || _.sizes) && (E.removeAttribute("srcset"), E.removeAttribute("sizes"), E.src = _.currentSrc || _.src);
              }
              function uA() {
                function CA(j, J) {
                  J.font = j.font, J.fontFamily = j.fontFamily, J.fontFeatureSettings = j.fontFeatureSettings, J.fontKerning = j.fontKerning, J.fontSize = j.fontSize, J.fontStretch = j.fontStretch, J.fontStyle = j.fontStyle, J.fontVariant = j.fontVariant, J.fontVariantCaps = j.fontVariantCaps, J.fontVariantEastAsian = j.fontVariantEastAsian, J.fontVariantLigatures = j.fontVariantLigatures, J.fontVariantNumeric = j.fontVariantNumeric, J.fontVariationSettings = j.fontVariationSettings, J.fontWeight = j.fontWeight;
                }
                function xA(j, J) {
                  let HA = f(j);
                  HA.cssText ? (J.style.cssText = HA.cssText, CA(HA, J.style)) : (V(u, j, HA, U, J), U === null && (["inset-block", "inset-block-start", "inset-block-end"].forEach((RA) => J.style.removeProperty(RA)), ["left", "right", "top", "bottom"].forEach((RA) => {
                    J.style.getPropertyValue(RA) && J.style.setProperty(RA, "0px");
                  })));
                }
                xA(_, E);
              }
              function wA() {
                let CA = t.uid();
                function xA(j) {
                  let J = f(_, j), HA = J.getPropertyValue("content");
                  if (HA !== "" && HA !== "none") {
                    let $e = function() {
                      let At = `.${CA}:` + j, hA = (J.cssText ? PA : Be)();
                      return document.createTextNode(At + `{${hA}}`);
                      function PA() {
                        return `${J.cssText} content: ${HA};`;
                      }
                      function Be() {
                        return t.asArray(J).map(XA).join("; ") + ";";
                        function XA(FA) {
                          let et = J.getPropertyValue(FA), fe = J.getPropertyPriority(FA) ? " !important" : "";
                          return FA + ": " + et + fe;
                        }
                      }
                    }, RA = E.getAttribute("class") || "", ge = (E.setAttribute("class", RA + " " + CA), document.createElement("style"));
                    ge.appendChild($e()), E.appendChild(ge);
                  }
                }
                [":before", ":after"].forEach(function(j) {
                  xA(j);
                });
              }
              function OA() {
                t.isHTMLTextAreaElement(_) && (E.innerHTML = _.value), t.isHTMLInputElement(_) && E.setAttribute("value", _.value);
              }
              function gA() {
                t.isSVGElement(E) && (E.setAttribute("xmlns", "http://www.w3.org/2000/svg"), t.isSVGRectElement(E)) && ["width", "height"].forEach(function(CA) {
                  let xA = E.getAttribute(CA);
                  xA && E.style.setProperty(CA, xA);
                });
              }
            }
          })(m, l, null);
        }).then(l.disableEmbedFonts ? Promise.resolve(Q) : K).then(l.disableInlineImages ? Promise.resolve(Q) : y).then(function(m) {
          l.bgcolor && (m.style.backgroundColor = l.bgcolor), l.width && (m.style.width = l.width + "px"), l.height && (m.style.height = l.height + "px"), l.style && Object.keys(l.style).forEach(function(I) {
            m.style[I] = l.style[I];
          });
          let R = null;
          return typeof l.onclone == "function" && (R = l.onclone(m)), Promise.resolve(R).then(function() {
            return m;
          });
        }).then(function(m) {
          let R = l.width || t.width(Q), I = l.height || t.height(Q);
          return Promise.resolve(m).then(function(u) {
            return u.setAttribute("xmlns", "http://www.w3.org/1999/xhtml"), new XMLSerializer().serializeToString(u);
          }).then(t.escapeXhtml).then(function(u) {
            var U = (t.isDimensionMissing(R) ? ' width="100%"' : ` width="${R}"`) + (t.isDimensionMissing(I) ? ' height="100%"' : ` height="${I}"`);
            return `<svg xmlns="http://www.w3.org/2000/svg"${(t.isDimensionMissing(R) ? "" : ` width="${R}"`) + (t.isDimensionMissing(I) ? "" : ` height="${I}"`)}><foreignObject${U}>${u}</foreignObject></svg>`;
          }).then(function(u) {
            return "data:image/svg+xml;charset=utf-8," + u;
          });
        }).then(function(m) {
          for (; 0 < C.length; ) {
            var R = C.pop();
            R.wrapper.replaceWith(R.child);
          }
          return m;
        }).then(function(m) {
          return o.impl.urlCache = [], b && (document.body.removeChild(b), b = null), M && clearTimeout(M), M = setTimeout(() => {
            M = null, D = {};
          }, 2e4), m;
        });
      }
      function F(Q, l) {
        return w(Q, l = l || {}).then(t.makeImage).then(function(C) {
          var m = typeof l.scale != "number" ? 1 : l.scale, R = ((u, U) => {
            let x = l.width || t.width(u), p = l.height || t.height(u);
            return t.isDimensionMissing(x) && (x = t.isDimensionMissing(p) ? 300 : 2 * p), t.isDimensionMissing(p) && (p = x / 2), (u = document.createElement("canvas")).width = x * U, u.height = p * U, l.bgcolor && ((U = u.getContext("2d")).fillStyle = l.bgcolor, U.fillRect(0, 0, u.width, u.height)), u;
          })(Q, m), I = R.getContext("2d");
          return I.msImageSmoothingEnabled = !1, I.imageSmoothingEnabled = !1, C && (I.scale(m, m), I.drawImage(C, 0, 0)), R;
        });
      }
      let b = null;
      function K(Q) {
        return s.resolveAll().then(function(l) {
          var C;
          return l !== "" && (C = document.createElement("style"), Q.appendChild(C), C.appendChild(document.createTextNode(l))), Q;
        });
      }
      function y(Q) {
        return i.inlineAll(Q).then(function() {
          return Q;
        });
      }
      function V(Q, l, C, m, R) {
        let I = o.impl.options.copyDefaultStyles ? ((U, x) => {
          var p, T = ((S) => (U.styleCaching !== "relaxed" ? S : S.filter((k, G, E) => G === 0 || G === E.length - 1)).join(">"))(x = ((S) => {
            var k = [];
            do
              if (S.nodeType === g) {
                var G = S.tagName;
                if (k.push(G), d.includes(G)) break;
              }
            while (S = S.parentNode);
            return k;
          })(x));
          {
            if (D[T]) return D[T];
            x = ((S, k) => {
              let G = S.body;
              do {
                var E = k.pop(), E = S.createElement(E);
                G.appendChild(E), G = E;
              } while (0 < k.length);
              return G.textContent = "​", G;
            })((p = (() => {
              if (b) return b.contentWindow;
              k = document.characterSet || "UTF-8", S = (S = document.doctype) ? (`<!DOCTYPE ${wA(S.name)} ${wA(S.publicId)} ` + wA(S.systemId)).trim() + ">" : "", (b = document.createElement("iframe")).id = "domtoimage-sandbox-" + t.uid(), b.style.top = "-9999px", b.style.visibility = "hidden", b.style.position = "fixed", document.body.appendChild(b);
              var S, k, G = b, E = "domtoimage-sandbox";
              try {
                return G.contentWindow.document.write(S + `<html><head><meta charset='${k}'><title>${E}</title></head><body></body></html>`), G.contentWindow;
              } catch {
              }
              var _ = document.createElement("meta");
              _.setAttribute("charset", k);
              try {
                var BA = document.implementation.createHTMLDocument(E), uA = (BA.head.appendChild(_), S + BA.documentElement.outerHTML);
                return G.setAttribute("srcdoc", uA), G.contentWindow;
              } catch {
              }
              return G.contentDocument.head.appendChild(_), G.contentDocument.title = E, G.contentWindow;
              function wA(OA) {
                var gA;
                return OA ? ((gA = document.createElement("div")).innerText = OA, gA.innerHTML) : "";
              }
            })()).document, x), p = ((S, k) => {
              let G = {}, E = S.getComputedStyle(k);
              return t.asArray(E).forEach(function(_) {
                G[_] = _ === "width" || _ === "height" ? "auto" : E.getPropertyValue(_);
              }), G;
            })(p, x);
            var X = x;
            do {
              var z = X.parentElement;
              z !== null && z.removeChild(X), X = z;
            } while (X && X.tagName !== "BODY");
            return D[T] = p;
          }
        })(Q, l) : {}, u = R.style;
        t.asArray(C).forEach(function(U) {
          var x, p, T, X;
          Q.filterStyles && !Q.filterStyles(l, U) || (p = C.getPropertyValue(U), T = I[U], x = m ? m.getPropertyValue(U) : void 0, u.getPropertyValue(U)) || (p !== T || m && p !== x) && (T = C.getPropertyPriority(U), x = u, p = p, T = T, X = 0 <= ["background-clip"].indexOf(U = U), T ? (x.setProperty(U, p, T), X && x.setProperty("-webkit-" + U, p, T)) : (x.setProperty(U, p), X && x.setProperty("-webkit-" + U, p)));
        });
      }
      let M = null, D = {}, d = ["ADDRESS", "ARTICLE", "ASIDE", "BLOCKQUOTE", "DETAILS", "DIALOG", "DD", "DIV", "DL", "DT", "FIELDSET", "FIGCAPTION", "FIGURE", "FOOTER", "FORM", "H1", "H2", "H3", "H4", "H5", "H6", "HEADER", "HGROUP", "HR", "LI", "MAIN", "NAV", "OL", "P", "PRE", "SECTION", "SVG", "TABLE", "UL", "math", "svg", "BODY", "HEAD", "HTML"];
    })(OB);
  })(St)), St.exports;
}
var GB = RB();
const VB = /* @__PURE__ */ MB(GB);
/*!
 * html2canvas 1.4.1 <https://html2canvas.hertzen.com>
 * Copyright (c) 2022 Niklas von Hertzen <https://hertzen.com>
 * Released under MIT License
 */
/*! *****************************************************************************
Copyright (c) Microsoft Corporation.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
***************************************************************************** */
var Vr = function(e, A) {
  return Vr = Object.setPrototypeOf || { __proto__: [] } instanceof Array && function(r, t) {
    r.__proto__ = t;
  } || function(r, t) {
    for (var n in t) Object.prototype.hasOwnProperty.call(t, n) && (r[n] = t[n]);
  }, Vr(e, A);
};
function MA(e, A) {
  if (typeof A != "function" && A !== null)
    throw new TypeError("Class extends value " + String(A) + " is not a constructor or null");
  Vr(e, A);
  function r() {
    this.constructor = e;
  }
  e.prototype = A === null ? Object.create(A) : (r.prototype = A.prototype, new r());
}
var Nr = function() {
  return Nr = Object.assign || function(A) {
    for (var r, t = 1, n = arguments.length; t < n; t++) {
      r = arguments[t];
      for (var s in r) Object.prototype.hasOwnProperty.call(r, s) && (A[s] = r[s]);
    }
    return A;
  }, Nr.apply(this, arguments);
};
function UA(e, A, r, t) {
  function n(s) {
    return s instanceof r ? s : new r(function(B) {
      B(s);
    });
  }
  return new (r || (r = Promise))(function(s, B) {
    function i(o) {
      try {
        c(t.next(o));
      } catch (g) {
        B(g);
      }
    }
    function a(o) {
      try {
        c(t.throw(o));
      } catch (g) {
        B(g);
      }
    }
    function c(o) {
      o.done ? s(o.value) : n(o.value).then(i, a);
    }
    c((t = t.apply(e, [])).next());
  });
}
function fA(e, A) {
  var r = { label: 0, sent: function() {
    if (s[0] & 1) throw s[1];
    return s[1];
  }, trys: [], ops: [] }, t, n, s, B;
  return B = { next: i(0), throw: i(1), return: i(2) }, typeof Symbol == "function" && (B[Symbol.iterator] = function() {
    return this;
  }), B;
  function i(c) {
    return function(o) {
      return a([c, o]);
    };
  }
  function a(c) {
    if (t) throw new TypeError("Generator is already executing.");
    for (; r; ) try {
      if (t = 1, n && (s = c[0] & 2 ? n.return : c[0] ? n.throw || ((s = n.return) && s.call(n), 0) : n.next) && !(s = s.call(n, c[1])).done) return s;
      switch (n = 0, s && (c = [c[0] & 2, s.value]), c[0]) {
        case 0:
        case 1:
          s = c;
          break;
        case 4:
          return r.label++, { value: c[1], done: !1 };
        case 5:
          r.label++, n = c[1], c = [0];
          continue;
        case 7:
          c = r.ops.pop(), r.trys.pop();
          continue;
        default:
          if (s = r.trys, !(s = s.length > 0 && s[s.length - 1]) && (c[0] === 6 || c[0] === 2)) {
            r = 0;
            continue;
          }
          if (c[0] === 3 && (!s || c[1] > s[0] && c[1] < s[3])) {
            r.label = c[1];
            break;
          }
          if (c[0] === 6 && r.label < s[1]) {
            r.label = s[1], s = c;
            break;
          }
          if (s && r.label < s[2]) {
            r.label = s[2], r.ops.push(c);
            break;
          }
          s[2] && r.ops.pop(), r.trys.pop();
          continue;
      }
      c = A.call(e, r);
    } catch (o) {
      c = [6, o], n = 0;
    } finally {
      t = s = 0;
    }
    if (c[0] & 5) throw c[1];
    return { value: c[0] ? c[1] : void 0, done: !0 };
  }
}
function lt(e, A, r) {
  if (arguments.length === 2) for (var t = 0, n = A.length, s; t < n; t++)
    (s || !(t in A)) && (s || (s = Array.prototype.slice.call(A, 0, t)), s[t] = A[t]);
  return e.concat(s || A);
}
var ZA = (
  /** @class */
  (function() {
    function e(A, r, t, n) {
      this.left = A, this.top = r, this.width = t, this.height = n;
    }
    return e.prototype.add = function(A, r, t, n) {
      return new e(this.left + A, this.top + r, this.width + t, this.height + n);
    }, e.fromClientRect = function(A, r) {
      return new e(r.left + A.windowBounds.left, r.top + A.windowBounds.top, r.width, r.height);
    }, e.fromDOMRectList = function(A, r) {
      var t = Array.from(r).find(function(n) {
        return n.width !== 0;
      });
      return t ? new e(t.left + A.windowBounds.left, t.top + A.windowBounds.top, t.width, t.height) : e.EMPTY;
    }, e.EMPTY = new e(0, 0, 0, 0), e;
  })()
), qt = function(e, A) {
  return ZA.fromClientRect(e, A.getBoundingClientRect());
}, NB = function(e) {
  var A = e.body, r = e.documentElement;
  if (!A || !r)
    throw new Error("Unable to get document size");
  var t = Math.max(Math.max(A.scrollWidth, r.scrollWidth), Math.max(A.offsetWidth, r.offsetWidth), Math.max(A.clientWidth, r.clientWidth)), n = Math.max(Math.max(A.scrollHeight, r.scrollHeight), Math.max(A.offsetHeight, r.offsetHeight), Math.max(A.clientHeight, r.clientHeight));
  return new ZA(0, 0, t, n);
}, zt = function(e) {
  for (var A = [], r = 0, t = e.length; r < t; ) {
    var n = e.charCodeAt(r++);
    if (n >= 55296 && n <= 56319 && r < t) {
      var s = e.charCodeAt(r++);
      (s & 64512) === 56320 ? A.push(((n & 1023) << 10) + (s & 1023) + 65536) : (A.push(n), r--);
    } else
      A.push(n);
  }
  return A;
}, nA = function() {
  for (var e = [], A = 0; A < arguments.length; A++)
    e[A] = arguments[A];
  if (String.fromCodePoint)
    return String.fromCodePoint.apply(String, e);
  var r = e.length;
  if (!r)
    return "";
  for (var t = [], n = -1, s = ""; ++n < r; ) {
    var B = e[n];
    B <= 65535 ? t.push(B) : (B -= 65536, t.push((B >> 10) + 55296, B % 1024 + 56320)), (n + 1 === r || t.length > 16384) && (s += String.fromCharCode.apply(String, t), t.length = 0);
  }
  return s;
}, vn = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", _B = typeof Uint8Array > "u" ? [] : new Uint8Array(256);
for (var ut = 0; ut < vn.length; ut++)
  _B[vn.charCodeAt(ut)] = ut;
var In = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", Me = typeof Uint8Array > "u" ? [] : new Uint8Array(256);
for (var gt = 0; gt < In.length; gt++)
  Me[In.charCodeAt(gt)] = gt;
var PB = function(e) {
  var A = e.length * 0.75, r = e.length, t, n = 0, s, B, i, a;
  e[e.length - 1] === "=" && (A--, e[e.length - 2] === "=" && A--);
  var c = typeof ArrayBuffer < "u" && typeof Uint8Array < "u" && typeof Uint8Array.prototype.slice < "u" ? new ArrayBuffer(A) : new Array(A), o = Array.isArray(c) ? c : new Uint8Array(c);
  for (t = 0; t < r; t += 4)
    s = Me[e.charCodeAt(t)], B = Me[e.charCodeAt(t + 1)], i = Me[e.charCodeAt(t + 2)], a = Me[e.charCodeAt(t + 3)], o[n++] = s << 2 | B >> 4, o[n++] = (B & 15) << 4 | i >> 2, o[n++] = (i & 3) << 6 | a & 63;
  return c;
}, XB = function(e) {
  for (var A = e.length, r = [], t = 0; t < A; t += 2)
    r.push(e[t + 1] << 8 | e[t]);
  return r;
}, kB = function(e) {
  for (var A = e.length, r = [], t = 0; t < A; t += 4)
    r.push(e[t + 3] << 24 | e[t + 2] << 16 | e[t + 1] << 8 | e[t]);
  return r;
}, le = 5, ln = 11, wr = 2, JB = ln - le, Ks = 65536 >> le, WB = 1 << le, Cr = WB - 1, YB = 1024 >> le, ZB = Ks + YB, qB = ZB, zB = 32, jB = qB + zB, $B = 65536 >> ln, Ai = 1 << JB, ei = Ai - 1, yn = function(e, A, r) {
  return e.slice ? e.slice(A, r) : new Uint16Array(Array.prototype.slice.call(e, A, r));
}, ti = function(e, A, r) {
  return e.slice ? e.slice(A, r) : new Uint32Array(Array.prototype.slice.call(e, A, r));
}, ri = function(e, A) {
  var r = PB(e), t = Array.isArray(r) ? kB(r) : new Uint32Array(r), n = Array.isArray(r) ? XB(r) : new Uint16Array(r), s = 24, B = yn(n, s / 2, t[4] / 2), i = t[5] === 2 ? yn(n, (s + t[4]) / 2) : ti(t, Math.ceil((s + t[4]) / 4));
  return new ni(t[0], t[1], t[2], t[3], B, i);
}, ni = (
  /** @class */
  (function() {
    function e(A, r, t, n, s, B) {
      this.initialValue = A, this.errorValue = r, this.highStart = t, this.highValueIndex = n, this.index = s, this.data = B;
    }
    return e.prototype.get = function(A) {
      var r;
      if (A >= 0) {
        if (A < 55296 || A > 56319 && A <= 65535)
          return r = this.index[A >> le], r = (r << wr) + (A & Cr), this.data[r];
        if (A <= 65535)
          return r = this.index[Ks + (A - 55296 >> le)], r = (r << wr) + (A & Cr), this.data[r];
        if (A < this.highStart)
          return r = jB - $B + (A >> ln), r = this.index[r], r += A >> le & ei, r = this.index[r], r = (r << wr) + (A & Cr), this.data[r];
        if (A <= 1114111)
          return this.data[this.highValueIndex];
      }
      return this.errorValue;
    }, e;
  })()
), Ln = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", si = typeof Uint8Array > "u" ? [] : new Uint8Array(256);
for (var ft = 0; ft < Ln.length; ft++)
  si[Ln.charCodeAt(ft)] = ft;
var Bi = "KwAAAAAAAAAACA4AUD0AADAgAAACAAAAAAAIABAAGABAAEgAUABYAGAAaABgAGgAYgBqAF8AZwBgAGgAcQB5AHUAfQCFAI0AlQCdAKIAqgCyALoAYABoAGAAaABgAGgAwgDKAGAAaADGAM4A0wDbAOEA6QDxAPkAAQEJAQ8BFwF1AH0AHAEkASwBNAE6AUIBQQFJAVEBWQFhAWgBcAF4ATAAgAGGAY4BlQGXAZ8BpwGvAbUBvQHFAc0B0wHbAeMB6wHxAfkBAQIJAvEBEQIZAiECKQIxAjgCQAJGAk4CVgJeAmQCbAJ0AnwCgQKJApECmQKgAqgCsAK4ArwCxAIwAMwC0wLbAjAA4wLrAvMC+AIAAwcDDwMwABcDHQMlAy0DNQN1AD0DQQNJA0kDSQNRA1EDVwNZA1kDdQB1AGEDdQBpA20DdQN1AHsDdQCBA4kDkQN1AHUAmQOhA3UAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AKYDrgN1AHUAtgO+A8YDzgPWAxcD3gPjA+sD8wN1AHUA+wMDBAkEdQANBBUEHQQlBCoEFwMyBDgEYABABBcDSARQBFgEYARoBDAAcAQzAXgEgASIBJAEdQCXBHUAnwSnBK4EtgS6BMIEyAR1AHUAdQB1AHUAdQCVANAEYABgAGAAYABgAGAAYABgANgEYADcBOQEYADsBPQE/AQEBQwFFAUcBSQFLAU0BWQEPAVEBUsFUwVbBWAAYgVgAGoFcgV6BYIFigWRBWAAmQWfBaYFYABgAGAAYABgAKoFYACxBbAFuQW6BcEFwQXHBcEFwQXPBdMF2wXjBeoF8gX6BQIGCgYSBhoGIgYqBjIGOgZgAD4GRgZMBmAAUwZaBmAAYABgAGAAYABgAGAAYABgAGAAYABgAGIGYABpBnAGYABgAGAAYABgAGAAYABgAGAAYAB4Bn8GhQZgAGAAYAB1AHcDFQSLBmAAYABgAJMGdQA9A3UAmwajBqsGqwaVALMGuwbDBjAAywbSBtIG1QbSBtIG0gbSBtIG0gbdBuMG6wbzBvsGAwcLBxMHAwcbByMHJwcsBywHMQcsB9IGOAdAB0gHTgfSBkgHVgfSBtIG0gbSBtIG0gbSBtIG0gbSBiwHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAdgAGAALAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAdbB2MHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsB2kH0gZwB64EdQB1AHUAdQB1AHUAdQB1AHUHfQdgAIUHjQd1AHUAlQedB2AAYAClB6sHYACzB7YHvgfGB3UAzgfWBzMB3gfmB1EB7gf1B/0HlQENAQUIDQh1ABUIHQglCBcDLQg1CD0IRQhNCEEDUwh1AHUAdQBbCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIaQhjCGQIZQhmCGcIaAhpCGMIZAhlCGYIZwhoCGkIYwhkCGUIZghnCGgIcAh3CHoIMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwAIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIgggwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAALAcsBywHLAcsBywHLAcsBywHLAcsB4oILAcsB44I0gaWCJ4Ipgh1AHUAqgiyCHUAdQB1AHUAdQB1AHUAdQB1AHUAtwh8AXUAvwh1AMUIyQjRCNkI4AjoCHUAdQB1AO4I9gj+CAYJDgkTCS0HGwkjCYIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiCCIIIggiAAIAAAAFAAYABgAGIAXwBgAHEAdQBFAJUAogCyAKAAYABgAEIA4ABGANMA4QDxAMEBDwE1AFwBLAE6AQEBUQF4QkhCmEKoQrhCgAHIQsAB0MLAAcABwAHAAeDC6ABoAHDCwMMAAcABwAHAAdDDGMMAAcAB6MM4wwjDWMNow3jDaABoAGgAaABoAGgAaABoAGgAaABoAGgAaABoAGgAaABoAGgAaABoAEjDqABWw6bDqABpg6gAaABoAHcDvwOPA+gAaABfA/8DvwO/A78DvwO/A78DvwO/A78DvwO/A78DvwO/A78DvwO/A78DvwO/A78DvwO/A78DvwO/A78DpcPAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcAB9cPKwkyCToJMAB1AHUAdQBCCUoJTQl1AFUJXAljCWcJawkwADAAMAAwAHMJdQB2CX4JdQCECYoJjgmWCXUAngkwAGAAYABxAHUApgn3A64JtAl1ALkJdQDACTAAMAAwADAAdQB1AHUAdQB1AHUAdQB1AHUAowYNBMUIMAAwADAAMADICcsJ0wnZCRUE4QkwAOkJ8An4CTAAMAB1AAAKvwh1AAgKDwoXCh8KdQAwACcKLgp1ADYKqAmICT4KRgowADAAdQB1AE4KMAB1AFYKdQBeCnUAZQowADAAMAAwADAAMAAwADAAMAAVBHUAbQowADAAdQC5CXUKMAAwAHwBxAijBogEMgF9CoQKiASMCpQKmgqIBKIKqgquCogEDQG2Cr4KxgrLCjAAMADTCtsKCgHjCusK8Qr5CgELMAAwADAAMAB1AIsECQsRC3UANAEZCzAAMAAwADAAMAB1ACELKQswAHUANAExCzkLdQBBC0kLMABRC1kLMAAwADAAMAAwADAAdQBhCzAAMAAwAGAAYABpC3ELdwt/CzAAMACHC4sLkwubC58Lpwt1AK4Ltgt1APsDMAAwADAAMAAwADAAMAAwAL4LwwvLC9IL1wvdCzAAMADlC+kL8Qv5C/8LSQswADAAMAAwADAAMAAwADAAMAAHDDAAMAAwADAAMAAODBYMHgx1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1ACYMMAAwADAAdQB1AHUALgx1AHUAdQB1AHUAdQA2DDAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwAHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AD4MdQBGDHUAdQB1AHUAdQB1AEkMdQB1AHUAdQB1AFAMMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwAHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQBYDHUAdQB1AF8MMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUA+wMVBGcMMAAwAHwBbwx1AHcMfwyHDI8MMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAYABgAJcMMAAwADAAdQB1AJ8MlQClDDAAMACtDCwHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsB7UMLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHdQB1AHUAdQB1AHUAdQB1AHUAdQB1AHUAdQB1AA0EMAC9DDAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAsBywHLAcsBywHLAcsBywHLQcwAMEMyAwsBywHLAcsBywHLAcsBywHLAcsBywHzAwwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwAHUAdQB1ANQM2QzhDDAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMABgAGAAYABgAGAAYABgAOkMYADxDGAA+AwADQYNYABhCWAAYAAODTAAMAAwADAAFg1gAGAAHg37AzAAMAAwADAAYABgACYNYAAsDTQNPA1gAEMNPg1LDWAAYABgAGAAYABgAGAAYABgAGAAUg1aDYsGVglhDV0NcQBnDW0NdQ15DWAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAlQCBDZUAiA2PDZcNMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAnw2nDTAAMAAwADAAMAAwAHUArw23DTAAMAAwADAAMAAwADAAMAAwADAAMAB1AL8NMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAB1AHUAdQB1AHUAdQDHDTAAYABgAM8NMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAA1w11ANwNMAAwAD0B5A0wADAAMAAwADAAMADsDfQN/A0EDgwOFA4wABsOMAAwADAAMAAwADAAMAAwANIG0gbSBtIG0gbSBtIG0gYjDigOwQUuDsEFMw7SBjoO0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIGQg5KDlIOVg7SBtIGXg5lDm0OdQ7SBtIGfQ6EDooOjQ6UDtIGmg6hDtIG0gaoDqwO0ga0DrwO0gZgAGAAYADEDmAAYAAkBtIGzA5gANIOYADaDokO0gbSBt8O5w7SBu8O0gb1DvwO0gZgAGAAxA7SBtIG0gbSBtIGYABgAGAAYAAED2AAsAUMD9IG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIGFA8sBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAccD9IGLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHJA8sBywHLAcsBywHLAccDywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywPLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAc0D9IG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIGLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAccD9IG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIGFA8sBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHLAcsBywHPA/SBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gbSBtIG0gYUD0QPlQCVAJUAMAAwADAAMACVAJUAlQCVAJUAlQCVAEwPMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAA//8EAAQABAAEAAQABAAEAAQABAANAAMAAQABAAIABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQACgATABcAHgAbABoAHgAXABYAEgAeABsAGAAPABgAHABLAEsASwBLAEsASwBLAEsASwBLABgAGAAeAB4AHgATAB4AUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQABYAGwASAB4AHgAeAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAWAA0AEQAeAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAAQABAAEAAQABAAFAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAJABYAGgAbABsAGwAeAB0AHQAeAE8AFwAeAA0AHgAeABoAGwBPAE8ADgBQAB0AHQAdAE8ATwAXAE8ATwBPABYAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAB0AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAdAFAAUABQAFAAUABQAFAAUAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAFAAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAeAB4AHgAeAFAATwBAAE8ATwBPAEAATwBQAFAATwBQAB4AHgAeAB4AHgAeAB0AHQAdAB0AHgAdAB4ADgBQAFAAUABQAFAAHgAeAB4AHgAeAB4AHgBQAB4AUAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4ABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAJAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAkACQAJAAkACQAJAAkABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAeAB4AHgAeAFAAHgAeAB4AKwArAFAAUABQAFAAGABQACsAKwArACsAHgAeAFAAHgBQAFAAUAArAFAAKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4ABAAEAAQABAAEAAQABAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAUAAeAB4AHgAeAB4AHgBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAYAA0AKwArAB4AHgAbACsABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQADQAEAB4ABAAEAB4ABAAEABMABAArACsAKwArACsAKwArACsAVgBWAFYAVgBWAFYAVgBWAFYAVgBWAFYAVgBWAFYAVgBWAFYAVgBWAFYAVgBWAFYAVgBWAFYAKwArACsAKwBWAFYAVgBWAB4AHgArACsAKwArACsAKwArACsAKwArACsAHgAeAB4AHgAeAB4AHgAeAB4AGgAaABoAGAAYAB4AHgAEAAQABAAEAAQABAAEAAQABAAEAAQAEwAEACsAEwATAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABABLAEsASwBLAEsASwBLAEsASwBLABoAGQAZAB4AUABQAAQAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQABMAUAAEAAQABAAEAAQABAAEAB4AHgAEAAQABAAEAAQABABQAFAABAAEAB4ABAAEAAQABABQAFAASwBLAEsASwBLAEsASwBLAEsASwBQAFAAUAAeAB4AUAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwAeAFAABABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAAEAAQABAAEAFAAKwArACsAKwArACsAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAAEAAQAUABQAB4AHgAYABMAUAArACsABAAbABsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAFAABAAEAAQABAAEAFAABAAEAAQAUAAEAAQABAAEAAQAKwArAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAArACsAHgArAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAKwArACsAKwArACsAKwArAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAB4ABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAEAFAABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQAUAAEAAQABAAEAAQABAAEAFAAUABQAFAAUABQAFAAUABQAFAABAAEAA0ADQBLAEsASwBLAEsASwBLAEsASwBLAB4AUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAArAFAAUABQAFAAUABQAFAAUAArACsAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQACsAUAArACsAKwBQAFAAUABQACsAKwAEAFAABAAEAAQABAAEAAQABAArACsABAAEACsAKwAEAAQABABQACsAKwArACsAKwArACsAKwAEACsAKwArACsAUABQACsAUABQAFAABAAEACsAKwBLAEsASwBLAEsASwBLAEsASwBLAFAAUAAaABoAUABQAFAAUABQAEwAHgAbAFAAHgAEACsAKwAEAAQABAArAFAAUABQAFAAUABQACsAKwArACsAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQACsAUABQACsAUABQACsAUABQACsAKwAEACsABAAEAAQABAAEACsAKwArACsABAAEACsAKwAEAAQABAArACsAKwAEACsAKwArACsAKwArACsAUABQAFAAUAArAFAAKwArACsAKwArACsAKwBLAEsASwBLAEsASwBLAEsASwBLAAQABABQAFAAUAAEAB4AKwArACsAKwArACsAKwArACsAKwAEAAQABAArAFAAUABQAFAAUABQAFAAUABQACsAUABQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQACsAUABQACsAUABQAFAAUABQACsAKwAEAFAABAAEAAQABAAEAAQABAAEACsABAAEAAQAKwAEAAQABAArACsAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwBQAFAABAAEACsAKwBLAEsASwBLAEsASwBLAEsASwBLAB4AGwArACsAKwArACsAKwArAFAABAAEAAQABAAEAAQAKwAEAAQABAArAFAAUABQAFAAUABQAFAAUAArACsAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAEAAQABAArACsABAAEACsAKwAEAAQABAArACsAKwArACsAKwArAAQABAAEACsAKwArACsAUABQACsAUABQAFAABAAEACsAKwBLAEsASwBLAEsASwBLAEsASwBLAB4AUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArAAQAUAArAFAAUABQAFAAUABQACsAKwArAFAAUABQACsAUABQAFAAUAArACsAKwBQAFAAKwBQACsAUABQACsAKwArAFAAUAArACsAKwBQAFAAUAArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArAAQABAAEAAQABAArACsAKwAEAAQABAArAAQABAAEAAQAKwArAFAAKwArACsAKwArACsABAArACsAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAUABQAFAAHgAeAB4AHgAeAB4AGwAeACsAKwArACsAKwAEAAQABAAEAAQAUABQAFAAUABQAFAAUABQACsAUABQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAUAAEAAQABAAEAAQABAAEACsABAAEAAQAKwAEAAQABAAEACsAKwArACsAKwArACsABAAEACsAUABQAFAAKwArACsAKwArAFAAUAAEAAQAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAKwAOAFAAUABQAFAAUABQAFAAHgBQAAQABAAEAA4AUABQAFAAUABQAFAAUABQACsAUABQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAKwArAAQAUAAEAAQABAAEAAQABAAEACsABAAEAAQAKwAEAAQABAAEACsAKwArACsAKwArACsABAAEACsAKwArACsAKwArACsAUAArAFAAUAAEAAQAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwBQAFAAKwArACsAKwArACsAKwArACsAKwArACsAKwAEAAQABAAEAFAAUABQAFAAUABQAFAAUABQACsAUABQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAFAABAAEAAQABAAEAAQABAArAAQABAAEACsABAAEAAQABABQAB4AKwArACsAKwBQAFAAUAAEAFAAUABQAFAAUABQAFAAUABQAFAABAAEACsAKwBLAEsASwBLAEsASwBLAEsASwBLAFAAUABQAFAAUABQAFAAUABQABoAUABQAFAAUABQAFAAKwAEAAQABAArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAUABQACsAUAArACsAUABQAFAAUABQAFAAUAArACsAKwAEACsAKwArACsABAAEAAQABAAEAAQAKwAEACsABAAEAAQABAAEAAQABAAEACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArAAQABAAeACsAKwArACsAKwArACsAKwArACsAKwArAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXAAqAFwAXAAqACoAKgAqACoAKgAqACsAKwArACsAGwBcAFwAXABcAFwAXABcACoAKgAqACoAKgAqACoAKgAeAEsASwBLAEsASwBLAEsASwBLAEsADQANACsAKwArACsAKwBcAFwAKwBcACsAXABcAFwAXABcACsAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcACsAXAArAFwAXABcAFwAXABcAFwAXABcAFwAKgBcAFwAKgAqACoAKgAqACoAKgAqACoAXAArACsAXABcAFwAXABcACsAXAArACoAKgAqACoAKgAqACsAKwBLAEsASwBLAEsASwBLAEsASwBLACsAKwBcAFwAXABcAFAADgAOAA4ADgAeAA4ADgAJAA4ADgANAAkAEwATABMAEwATAAkAHgATAB4AHgAeAAQABAAeAB4AHgAeAB4AHgBLAEsASwBLAEsASwBLAEsASwBLAFAAUABQAFAAUABQAFAAUABQAFAADQAEAB4ABAAeAAQAFgARABYAEQAEAAQAUABQAFAAUABQAFAAUABQACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAKwAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQADQAEAAQABAAEAAQADQAEAAQAUABQAFAAUABQAAQABAAEAAQABAAEAAQABAAEAAQABAArAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAArAA0ADQAeAB4AHgAeAB4AHgAEAB4AHgAeAB4AHgAeACsAHgAeAA4ADgANAA4AHgAeAB4AHgAeAAkACQArACsAKwArACsAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgBcAEsASwBLAEsASwBLAEsASwBLAEsADQANAB4AHgAeAB4AXABcAFwAXABcAFwAKgAqACoAKgBcAFwAXABcACoAKgAqAFwAKgAqACoAXABcACoAKgAqACoAKgAqACoAXABcAFwAKgAqACoAKgBcAFwAXABcAFwAXABcAFwAXABcAFwAXABcACoAKgAqACoAKgAqACoAKgAqACoAKgAqAFwAKgBLAEsASwBLAEsASwBLAEsASwBLACoAKgAqACoAKgAqAFAAUABQAFAAUABQACsAUAArACsAKwArACsAUAArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAHgBQAFAAUABQAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFAAUABQAFAAUABQAFAAUABQACsAUABQAFAAUAArACsAUABQAFAAUABQAFAAUAArAFAAKwBQAFAAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAKwArAFAAUABQAFAAUABQAFAAKwBQACsAUABQAFAAUAArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsABAAEAAQAHgANAB4AHgAeAB4AHgAeAB4AUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAHgAeAB4AHgAeAB4AHgAeAB4AHgArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwBQAFAAUABQAFAAUAArACsADQBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAHgAeAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAANAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAWABEAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAA0ADQANAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAAQABAAEACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAANAA0AKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEACsAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUAArAAQABAArACsAKwArACsAKwArACsAKwArACsAKwBcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqAA0ADQAVAFwADQAeAA0AGwBcACoAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwAeAB4AEwATAA0ADQAOAB4AEwATAB4ABAAEAAQACQArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArAFAAUABQAFAAUAAEAAQAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQAUAArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwAEAAQABAAEAAQABAAEAAQABAAEAAQABAArACsAKwArAAQABAAEAAQABAAEAAQABAAEAAQABAAEACsAKwArACsAHgArACsAKwATABMASwBLAEsASwBLAEsASwBLAEsASwBcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXAArACsAXABcAFwAXABcACsAKwArACsAKwArACsAKwArACsAKwBcAFwAXABcAFwAXABcAFwAXABcAFwAXAArACsAKwArAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAXAArACsAKwAqACoAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAEAAQABAArACsAHgAeAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcACoAKgAqACoAKgAqACoAKgAqACoAKwAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKwArAAQASwBLAEsASwBLAEsASwBLAEsASwArACsAKwArACsAKwBLAEsASwBLAEsASwBLAEsASwBLACsAKwArACsAKwArACoAKgAqACoAKgAqACoAXAAqACoAKgAqACoAKgArACsABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsABAAEAAQABAAEAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAEAAQABABQAFAAUABQAFAAUABQACsAKwArACsASwBLAEsASwBLAEsASwBLAEsASwANAA0AHgANAA0ADQANAB4AHgAeAB4AHgAeAB4AHgAeAB4ABAAEAAQABAAEAAQABAAEAAQAHgAeAB4AHgAeAB4AHgAeAB4AKwArACsABAAEAAQAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAAEAAQABAAEAAQABABQAFAASwBLAEsASwBLAEsASwBLAEsASwBQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEACsAKwArACsAKwArACsAKwAeAB4AHgAeAFAAUABQAFAABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEACsAKwArAA0ADQANAA0ADQBLAEsASwBLAEsASwBLAEsASwBLACsAKwArAFAAUABQAEsASwBLAEsASwBLAEsASwBLAEsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAA0ADQBQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwBQAFAAUAAeAB4AHgAeAB4AHgAeAB4AKwArACsAKwArACsAKwArAAQABAAEAB4ABAAEAAQABAAEAAQABAAEAAQABAAEAAQABABQAFAAUABQAAQAUABQAFAAUABQAFAABABQAFAABAAEAAQAUAArACsAKwArACsABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEACsABAAEAAQABAAEAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwArAFAAUABQAFAAUABQACsAKwBQAFAAUABQAFAAUABQAFAAKwBQACsAUAArAFAAKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeACsAKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArAB4AHgAeAB4AHgAeAB4AHgBQAB4AHgAeAFAAUABQACsAHgAeAB4AHgAeAB4AHgAeAB4AHgBQAFAAUABQACsAKwAeAB4AHgAeAB4AHgArAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwArAFAAUABQACsAHgAeAB4AHgAeAB4AHgAOAB4AKwANAA0ADQANAA0ADQANAAkADQANAA0ACAAEAAsABAAEAA0ACQANAA0ADAAdAB0AHgAXABcAFgAXABcAFwAWABcAHQAdAB4AHgAUABQAFAANAAEAAQAEAAQABAAEAAQACQAaABoAGgAaABoAGgAaABoAHgAXABcAHQAVABUAHgAeAB4AHgAeAB4AGAAWABEAFQAVABUAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4ADQAeAA0ADQANAA0AHgANAA0ADQAHAB4AHgAeAB4AKwAEAAQABAAEAAQABAAEAAQABAAEAFAAUAArACsATwBQAFAAUABQAFAAHgAeAB4AFgARAE8AUABPAE8ATwBPAFAAUABQAFAAUAAeAB4AHgAWABEAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArABsAGwAbABsAGwAbABsAGgAbABsAGwAbABsAGwAbABsAGwAbABsAGwAbABsAGgAbABsAGwAbABoAGwAbABoAGwAbABsAGwAbABsAGwAbABsAGwAbABsAGwAbABsAGwAbAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQAHgAeAFAAGgAeAB0AHgBQAB4AGgAeAB4AHgAeAB4AHgAeAB4AHgBPAB4AUAAbAB4AHgBQAFAAUABQAFAAHgAeAB4AHQAdAB4AUAAeAFAAHgBQAB4AUABPAFAAUAAeAB4AHgAeAB4AHgAeAFAAUABQAFAAUAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAFAAHgBQAFAAUABQAE8ATwBQAFAAUABQAFAATwBQAFAATwBQAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAFAAUABQAFAATwBPAE8ATwBPAE8ATwBPAE8ATwBQAFAAUABQAFAAUABQAFAAUAAeAB4AUABQAFAAUABPAB4AHgArACsAKwArAB0AHQAdAB0AHQAdAB0AHQAdAB0AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB0AHgAdAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAdAB4AHQAdAB4AHgAeAB0AHQAeAB4AHQAeAB4AHgAdAB4AHQAbABsAHgAdAB4AHgAeAB4AHQAeAB4AHQAdAB0AHQAeAB4AHQAeAB0AHgAdAB0AHQAdAB0AHQAeAB0AHgAeAB4AHgAeAB0AHQAdAB0AHgAeAB4AHgAdAB0AHgAeAB4AHgAeAB4AHgAeAB4AHgAdAB4AHgAeAB0AHgAeAB4AHgAeAB0AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAdAB0AHgAeAB0AHQAdAB0AHgAeAB0AHQAeAB4AHQAdAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB0AHQAeAB4AHQAdAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHQAeAB4AHgAdAB4AHgAeAB4AHgAeAB4AHQAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB0AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AFAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeABYAEQAWABEAHgAeAB4AHgAeAB4AHQAeAB4AHgAeAB4AHgAeACUAJQAeAB4AHgAeAB4AHgAeAB4AHgAWABEAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AJQAlACUAJQAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAFAAHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHgAeAB4AHgAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAeAB4AHQAdAB0AHQAeAB4AHgAeAB4AHgAeAB4AHgAeAB0AHQAeAB0AHQAdAB0AHQAdAB0AHgAeAB4AHgAeAB4AHgAeAB0AHQAeAB4AHQAdAB4AHgAeAB4AHQAdAB4AHgAeAB4AHQAdAB0AHgAeAB0AHgAeAB0AHQAdAB0AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAdAB0AHQAdAB4AHgAeAB4AHgAeAB4AHgAeAB0AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAlACUAJQAlAB4AHQAdAB4AHgAdAB4AHgAeAB4AHQAdAB4AHgAeAB4AJQAlAB0AHQAlAB4AJQAlACUAIAAlACUAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAlACUAJQAeAB4AHgAeAB0AHgAdAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAdAB0AHgAdAB0AHQAeAB0AJQAdAB0AHgAdAB0AHgAdAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeACUAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHQAdAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAlACUAJQAlACUAJQAlACUAJQAlACUAJQAdAB0AHQAdACUAHgAlACUAJQAdACUAJQAdAB0AHQAlACUAHQAdACUAHQAdACUAJQAlAB4AHQAeAB4AHgAeAB0AHQAlAB0AHQAdAB0AHQAdACUAJQAlACUAJQAdACUAJQAgACUAHQAdACUAJQAlACUAJQAlACUAJQAeAB4AHgAlACUAIAAgACAAIAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB0AHgAeAB4AFwAXABcAFwAXABcAHgATABMAJQAeAB4AHgAWABEAFgARABYAEQAWABEAFgARABYAEQAWABEATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeABYAEQAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAWABEAFgARABYAEQAWABEAFgARAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AFgARABYAEQAWABEAFgARABYAEQAWABEAFgARABYAEQAWABEAFgARABYAEQAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAWABEAFgARAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AFgARAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAdAB0AHQAdAB0AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArACsAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AUABQAFAAUAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAEAAQABAAeAB4AKwArACsAKwArABMADQANAA0AUAATAA0AUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAUAANACsAKwArACsAKwArACsAKwArACsAKwArACsAKwAEAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQACsAUABQAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQACsAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXAA0ADQANAA0ADQANAA0ADQAeAA0AFgANAB4AHgAXABcAHgAeABcAFwAWABEAFgARABYAEQAWABEADQANAA0ADQATAFAADQANAB4ADQANAB4AHgAeAB4AHgAMAAwADQANAA0AHgANAA0AFgANAA0ADQANAA0ADQANAA0AHgANAB4ADQANAB4AHgAeACsAKwArACsAKwArACsAKwArACsAKwArACsAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACsAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAKwArACsAKwArACsAKwArACsAKwArACsAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwAlACUAJQAlACUAJQAlACUAJQAlACUAJQArACsAKwArAA0AEQARACUAJQBHAFcAVwAWABEAFgARABYAEQAWABEAFgARACUAJQAWABEAFgARABYAEQAWABEAFQAWABEAEQAlAFcAVwBXAFcAVwBXAFcAVwBXAAQABAAEAAQABAAEACUAVwBXAFcAVwA2ACUAJQBXAFcAVwBHAEcAJQAlACUAKwBRAFcAUQBXAFEAVwBRAFcAUQBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFEAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBRAFcAUQBXAFEAVwBXAFcAVwBXAFcAUQBXAFcAVwBXAFcAVwBRAFEAKwArAAQABAAVABUARwBHAFcAFQBRAFcAUQBXAFEAVwBRAFcAUQBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFEAVwBRAFcAUQBXAFcAVwBXAFcAVwBRAFcAVwBXAFcAVwBXAFEAUQBXAFcAVwBXABUAUQBHAEcAVwArACsAKwArACsAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAKwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAKwAlACUAVwBXAFcAVwAlACUAJQAlACUAJQAlACUAJQAlACsAKwArACsAKwArACsAKwArACsAKwArAFEAUQBRAFEAUQBRAFEAUQBRAFEAUQBRAFEAUQBRAFEAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQArAFcAVwBXAFcAVwBXAFcAVwBXAFcAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQBPAE8ATwBPAE8ATwBPAE8AJQBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXACUAJQAlAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAEcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAKwArACsAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAADQATAA0AUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABLAEsASwBLAEsASwBLAEsASwBLAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAFAABAAEAAQABAAeAAQABAAEAAQABAAEAAQABAAEAAQAHgBQAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AUABQAAQABABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAeAA0ADQANAA0ADQArACsAKwArACsAKwArACsAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAFAAUABQAFAAUABQAFAAUABQAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AUAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgBQAB4AHgAeAB4AHgAeAFAAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArACsAHgAeAB4AHgAeAB4AHgAeAB4AKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwAeAB4AUABQAFAAUABQAFAAUABQAFAAUABQAAQAUABQAFAABABQAFAAUABQAAQAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAEAAQABAAeAB4AHgAeAAQAKwArACsAUABQAFAAUABQAFAAHgAeABoAHgArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAADgAOABMAEwArACsAKwArACsAKwArACsABAAEAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAEAAQABAAEACsAKwArACsAKwArACsAKwANAA0ASwBLAEsASwBLAEsASwBLAEsASwArACsAKwArACsAKwAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABABQAFAAUABQAFAAUAAeAB4AHgBQAA4AUABQAAQAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAAEAA0ADQBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQAKwArACsAKwArACsAKwArACsAKwArAB4AWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYAFgAWABYACsAKwArAAQAHgAeAB4AHgAeAB4ADQANAA0AHgAeAB4AHgArAFAASwBLAEsASwBLAEsASwBLAEsASwArACsAKwArAB4AHgBcAFwAXABcAFwAKgBcAFwAXABcAFwAXABcAFwAXABcAEsASwBLAEsASwBLAEsASwBLAEsAXABcAFwAXABcACsAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEACsAKwArACsAKwArACsAKwArAFAAUABQAAQAUABQAFAAUABQAFAAUABQAAQABAArACsASwBLAEsASwBLAEsASwBLAEsASwArACsAHgANAA0ADQBcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAKgAqACoAXAAqACoAKgBcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXAAqAFwAKgAqACoAXABcACoAKgBcAFwAXABcAFwAKgAqAFwAKgBcACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFwAXABcACoAKgBQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAA0ADQBQAFAAUAAEAAQAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUAArACsAUABQAFAAUABQAFAAKwArAFAAUABQAFAAUABQACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAHgAeACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAAQADQAEAAQAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAVABVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBUAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVAFUAVQBVACsAKwArACsAKwArACsAKwArACsAKwArAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAKwArACsAKwBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAKwArACsAKwAGAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAYABgAGAAYAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXACUAJQBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAJQAlACUAJQAlACUAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAKwArACsAKwArAFYABABWAFYAVgBWAFYAVgBWAFYAVgBWAB4AVgBWAFYAVgBWAFYAVgBWAFYAVgBWAFYAVgArAFYAVgBWAFYAVgArAFYAKwBWAFYAKwBWAFYAKwBWAFYAVgBWAFYAVgBWAFYAVgBWAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAEQAWAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUAAaAB4AKwArAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQAGAARABEAGAAYABMAEwAWABEAFAArACsAKwArACsAKwAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEACUAJQAlACUAJQAWABEAFgARABYAEQAWABEAFgARABYAEQAlACUAFgARACUAJQAlACUAJQAlACUAEQAlABEAKwAVABUAEwATACUAFgARABYAEQAWABEAJQAlACUAJQAlACUAJQAlACsAJQAbABoAJQArACsAKwArAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArAAcAKwATACUAJQAbABoAJQAlABYAEQAlACUAEQAlABEAJQBXAFcAVwBXAFcAVwBXAFcAVwBXABUAFQAlACUAJQATACUAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXABYAJQARACUAJQAlAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwAWACUAEQAlABYAEQARABYAEQARABUAVwBRAFEAUQBRAFEAUQBRAFEAUQBRAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAEcARwArACsAVwBXAFcAVwBXAFcAKwArAFcAVwBXAFcAVwBXACsAKwBXAFcAVwBXAFcAVwArACsAVwBXAFcAKwArACsAGgAbACUAJQAlABsAGwArAB4AHgAeAB4AHgAeAB4AKwArACsAKwArACsAKwArACsAKwAEAAQABAAQAB0AKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsADQANAA0AKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArAB4AHgAeAB4AHgAeAB4AHgAeAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgBQAFAAHgAeAB4AKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAAQAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwAEAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAA0AUABQAFAAUAArACsAKwArAFAAUABQAFAAUABQAFAAUAANAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAKwArACsAKwAeACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAKwArAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUAArACsAKwBQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwANAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAeAB4AUABQAFAAUABQAFAAUAArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUAArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArAA0AUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwAeAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAUABQAFAAUABQAAQABAAEACsABAAEACsAKwArACsAKwAEAAQABAAEAFAAUABQAFAAKwBQAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArAAQABAAEACsAKwArACsABABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArAA0ADQANAA0ADQANAA0ADQAeACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAeAFAAUABQAFAAUABQAFAAUAAeAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAArACsAKwArAFAAUABQAFAAUAANAA0ADQANAA0ADQAUACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsADQANAA0ADQANAA0ADQBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArAB4AHgAeAB4AKwArACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArAFAAUABQAFAAUABQAAQABAAEAAQAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUAArAAQABAANACsAKwBQAFAAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAAQABAAEAAQABAAEAAQABAAEAAQABABQAFAAUABQAB4AHgAeAB4AHgArACsAKwArACsAKwAEAAQABAAEAAQABAAEAA0ADQAeAB4AHgAeAB4AKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsABABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAQABAAEAAQABAAEAAQABAAEAAQABAAeAB4AHgANAA0ADQANACsAKwArACsAKwArACsAKwArACsAKwAeACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAKwArACsAKwBLAEsASwBLAEsASwBLAEsASwBLACsAKwArACsAKwArAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEACsASwBLAEsASwBLAEsASwBLAEsASwANAA0ADQANAFAABAAEAFAAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAeAA4AUAArACsAKwArACsAKwArACsAKwAEAFAAUABQAFAADQANAB4ADQAEAAQABAAEAB4ABAAEAEsASwBLAEsASwBLAEsASwBLAEsAUAAOAFAADQANAA0AKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAAQABAAEAAQABAANAA0AHgANAA0AHgAEACsAUABQAFAAUABQAFAAUAArAFAAKwBQAFAAUABQACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAA0AKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAAQABAAEAAQAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsABAAEAAQABAArAFAAUABQAFAAUABQAFAAUAArACsAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQACsAUABQACsAUABQAFAAUABQACsABAAEAFAABAAEAAQABAAEAAQABAArACsABAAEACsAKwAEAAQABAArACsAUAArACsAKwArACsAKwAEACsAKwArACsAKwBQAFAAUABQAFAABAAEACsAKwAEAAQABAAEAAQABAAEACsAKwArAAQABAAEAAQABAArACsAKwArACsAKwArACsAKwArACsABAAEAAQABAAEAAQABABQAFAAUABQAA0ADQANAA0AHgBLAEsASwBLAEsASwBLAEsASwBLAA0ADQArAB4ABABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwAEAAQABAAEAFAAUAAeAFAAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAArACsABAAEAAQABAAEAAQABAAEAAQADgANAA0AEwATAB4AHgAeAA0ADQANAA0ADQANAA0ADQANAA0ADQANAA0ADQANAFAAUABQAFAABAAEACsAKwAEAA0ADQAeAFAAKwArACsAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAFAAKwArACsAKwArACsAKwBLAEsASwBLAEsASwBLAEsASwBLACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAXABcAFwAKwArACoAKgAqACoAKgAqACoAKgAqACoAKgAqACoAKgAqACsAKwArACsASwBLAEsASwBLAEsASwBLAEsASwBcAFwADQANAA0AKgBQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAeACsAKwArACsASwBLAEsASwBLAEsASwBLAEsASwBQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAKwArAFAAKwArAFAAUABQAFAAUABQAFAAUAArAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQAKwAEAAQAKwArAAQABAAEAAQAUAAEAFAABAAEAA0ADQANACsAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAArACsABAAEAAQABAAEAAQABABQAA4AUAAEACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFAABAAEAAQABAAEAAQABAAEAAQABABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAFAABAAEAAQABAAOAB4ADQANAA0ADQAOAB4ABAArACsAKwArACsAKwArACsAUAAEAAQABAAEAAQABAAEAAQABAAEAAQAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAA0ADQANAFAADgAOAA4ADQANACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAEAAQABAAEACsABAAEAAQABAAEAAQABAAEAFAADQANAA0ADQANACsAKwArACsAKwArACsAKwArACsASwBLAEsASwBLAEsASwBLAEsASwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwAOABMAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAArAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQACsAUABQACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAArACsAKwAEACsABAAEACsABAAEAAQABAAEAAQABABQAAQAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAUABQAFAAUABQAFAAKwBQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQAKwAEAAQAKwAEAAQABAAEAAQAUAArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAABAAEAAQABAAeAB4AKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwBQACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAB4AHgAeAB4AHgAeAB4AHgAaABoAGgAaAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArACsAKwArACsAKwArACsAKwArACsAKwArAA0AUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsADQANAA0ADQANACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAASABIAEgAQwBDAEMAUABQAFAAUABDAFAAUABQAEgAQwBIAEMAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAASABDAEMAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwAJAAkACQAJAAkACQAJABYAEQArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABIAEMAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwANAA0AKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArAAQABAAEAAQABAANACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEAA0ADQANAB4AHgAeAB4AHgAeAFAAUABQAFAADQAeACsAKwArACsAKwArACsAKwArACsASwBLAEsASwBLAEsASwBLAEsASwArAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAANAA0AHgAeACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAKwAEAFAABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQAKwArACsAKwArACsAKwAEAAQABAAEAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAARwBHABUARwAJACsAKwArACsAKwArACsAKwArACsAKwAEAAQAKwArACsAKwArACsAKwArACsAKwArACsAKwArAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXACsAKwArACsAKwArACsAKwBXAFcAVwBXAFcAVwBXAFcAVwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAUQBRAFEAKwArACsAKwArACsAKwArACsAKwArACsAKwBRAFEAUQBRACsAKwArACsAKwArACsAKwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUAArACsAHgAEAAQADQAEAAQABAAEACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArACsAKwArACsAKwArACsAKwArAB4AHgAeAB4AHgAeAB4AKwArAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAAQABAAEAAQABAAeAB4AHgAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAB4AHgAEAAQABAAEAAQABAAEAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4ABAAEAAQABAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4ABAAEAAQAHgArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwArACsAKwArACsAKwArACsAKwArAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArACsAKwArACsAKwArACsAKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwBQAFAAKwArAFAAKwArAFAAUAArACsAUABQAFAAUAArAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeACsAUAArAFAAUABQAFAAUABQAFAAKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwBQAFAAUABQACsAKwBQAFAAUABQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQACsAHgAeAFAAUABQAFAAUAArAFAAKwArACsAUABQAFAAUABQAFAAUAArAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAHgBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgBQAFAAUABQAFAAUABQAFAAUABQAFAAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAB4AHgAeAB4AHgAeAB4AHgAeACsAKwBLAEsASwBLAEsASwBLAEsASwBLAEsASwBLAEsASwBLAEsASwBLAEsASwBLAEsASwBLAEsASwBLAEsASwBLAEsASwBLAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAeAB4AHgAeAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAeAB4AHgAeAB4AHgAeAB4ABAAeAB4AHgAeAB4AHgAeAB4AHgAeAAQAHgAeAA0ADQANAA0AHgArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwAEAAQABAAEAAQAKwAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAAQABAAEAAQABAAEAAQAKwAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQAKwArAAQABAAEAAQABAAEAAQAKwAEAAQAKwAEAAQABAAEAAQAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwAEAAQABAAEAAQABAAEAFAAUABQAFAAUABQAFAAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwBQAB4AKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArABsAUABQAFAAUABQACsAKwBQAFAAUABQAFAAUABQAFAAUAAEAAQABAAEAAQABAAEACsAKwArACsAKwArACsAKwArAB4AHgAeAB4ABAAEAAQABAAEAAQABABQACsAKwArACsASwBLAEsASwBLAEsASwBLAEsASwArACsAKwArABYAFgArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAGgBQAFAAUAAaAFAAUABQAFAAKwArACsAKwArACsAKwArACsAKwArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAeAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQACsAKwBQAFAAUABQACsAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwBQAFAAKwBQACsAKwBQACsAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAKwBQACsAUAArACsAKwArACsAKwBQACsAKwArACsAUAArAFAAKwBQACsAUABQAFAAKwBQAFAAKwBQACsAKwBQACsAUAArAFAAKwBQACsAUAArAFAAUAArAFAAKwArAFAAUABQAFAAKwBQAFAAUABQAFAAUABQACsAUABQAFAAUAArAFAAUABQAFAAKwBQACsAUABQAFAAUABQAFAAUABQAFAAUAArAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAArACsAKwArACsAUABQAFAAKwBQAFAAUABQAFAAKwBQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwAeAB4AKwArACsAKwArACsAKwArACsAKwArACsAKwArAE8ATwBPAE8ATwBPAE8ATwBPAE8ATwBPAE8AJQAlACUAHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHgAeAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB4AHgAeACUAJQAlAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAdAB0AHQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQApACkAKQApACkAKQApACkAKQApACkAKQApACkAKQApACkAKQApACkAKQApACkAKQApACkAJQAlACUAJQAlACAAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAeAB4AJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlAB4AHgAlACUAJQAlACUAHgAlACUAJQAlACUAIAAgACAAJQAlACAAJQAlACAAIAAgACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACEAIQAhACEAIQAlACUAIAAgACUAJQAgACAAIAAgACAAIAAgACAAIAAgACAAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAJQAlACUAIAAlACUAJQAlACAAIAAgACUAIAAgACAAJQAlACUAJQAlACUAJQAgACUAIAAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAHgAlAB4AJQAeACUAJQAlACUAJQAgACUAJQAlACUAHgAlAB4AHgAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlAB4AHgAeAB4AHgAeAB4AJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAeAB4AHgAeAB4AHgAeAB4AHgAeACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACAAIAAlACUAJQAlACAAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACAAJQAlACUAJQAgACAAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAHgAeAB4AHgAeAB4AHgAeACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAeAB4AHgAeAB4AHgAlACUAJQAlACUAJQAlACAAIAAgACUAJQAlACAAIAAgACAAIAAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeABcAFwAXABUAFQAVAB4AHgAeAB4AJQAlACUAIAAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACAAIAAgACUAJQAlACUAJQAlACUAJQAlACAAJQAlACUAJQAlACUAJQAlACUAJQAlACAAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AJQAlACUAJQAlACUAJQAlACUAJQAlACUAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AJQAlACUAJQAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeACUAJQAlACUAJQAlACUAJQAeAB4AHgAeAB4AHgAeAB4AHgAeACUAJQAlACUAJQAlAB4AHgAeAB4AHgAeAB4AHgAlACUAJQAlACUAJQAlACUAHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAgACUAJQAgACUAJQAlACUAJQAlACUAJQAgACAAIAAgACAAIAAgACAAJQAlACUAJQAlACUAIAAlACUAJQAlACUAJQAlACUAJQAgACAAIAAgACAAIAAgACAAIAAgACUAJQAgACAAIAAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAgACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACAAIAAlACAAIAAlACAAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAgACAAIAAlACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAJQAlAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AKwAeAB4AHgAeAB4AHgAeAB4AHgAeAB4AHgArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAEsASwBLAEsASwBLAEsASwBLAEsAKwArACsAKwArACsAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAKwArAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXACUAJQBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwAlACUAJQAlACUAJQAlACUAJQAlACUAVwBXACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQBXAFcAVwBXAFcAVwBXAFcAVwBXAFcAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAJQAlACUAKwAEACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArACsAKwArAA==", Kn = 50, ii = 1, xs = 2, bs = 3, ai = 4, oi = 5, xn = 7, Ds = 8, bn = 9, Ae = 10, _r = 11, Dn = 12, Pr = 13, ci = 14, Oe = 15, Xr = 16, Qt = 17, be = 18, li = 19, Tn = 20, kr = 21, De = 22, hr = 23, he = 24, EA = 25, Re = 26, Ge = 27, Ue = 28, ui = 29, oe = 30, gi = 31, wt = 32, Ct = 33, Jr = 34, Wr = 35, Yr = 36, Ye = 37, Zr = 38, Mt = 39, Ot = 40, Ur = 41, Ts = 42, fi = 43, Qi = [9001, 65288], Ss = "!", N = "×", ht = "÷", qr = ri(Bi), JA = [oe, Yr], zr = [ii, xs, bs, oi], Ms = [Ae, Ds], Sn = [Ge, Re], wi = zr.concat(Ms), Mn = [Zr, Mt, Ot, Jr, Wr], Ci = [Oe, Pr], hi = function(e, A) {
  A === void 0 && (A = "strict");
  var r = [], t = [], n = [];
  return e.forEach(function(s, B) {
    var i = qr.get(s);
    if (i > Kn ? (n.push(!0), i -= Kn) : n.push(!1), ["normal", "auto", "loose"].indexOf(A) !== -1 && [8208, 8211, 12316, 12448].indexOf(s) !== -1)
      return t.push(B), r.push(Xr);
    if (i === ai || i === _r) {
      if (B === 0)
        return t.push(B), r.push(oe);
      var a = r[B - 1];
      return wi.indexOf(a) === -1 ? (t.push(t[B - 1]), r.push(a)) : (t.push(B), r.push(oe));
    }
    if (t.push(B), i === gi)
      return r.push(A === "strict" ? kr : Ye);
    if (i === Ts || i === ui)
      return r.push(oe);
    if (i === fi)
      return s >= 131072 && s <= 196605 || s >= 196608 && s <= 262141 ? r.push(Ye) : r.push(oe);
    r.push(i);
  }), [t, r, n];
}, Fr = function(e, A, r, t) {
  var n = t[r];
  if (Array.isArray(e) ? e.indexOf(n) !== -1 : e === n)
    for (var s = r; s <= t.length; ) {
      s++;
      var B = t[s];
      if (B === A)
        return !0;
      if (B !== Ae)
        break;
    }
  if (n === Ae)
    for (var s = r; s > 0; ) {
      s--;
      var i = t[s];
      if (Array.isArray(e) ? e.indexOf(i) !== -1 : e === i)
        for (var a = r; a <= t.length; ) {
          a++;
          var B = t[a];
          if (B === A)
            return !0;
          if (B !== Ae)
            break;
        }
      if (i !== Ae)
        break;
    }
  return !1;
}, On = function(e, A) {
  for (var r = e; r >= 0; ) {
    var t = A[r];
    if (t === Ae)
      r--;
    else
      return t;
  }
  return 0;
}, Ui = function(e, A, r, t, n) {
  if (r[t] === 0)
    return N;
  var s = t - 1;
  if (Array.isArray(n) && n[s] === !0)
    return N;
  var B = s - 1, i = s + 1, a = A[s], c = B >= 0 ? A[B] : 0, o = A[i];
  if (a === xs && o === bs)
    return N;
  if (zr.indexOf(a) !== -1)
    return Ss;
  if (zr.indexOf(o) !== -1 || Ms.indexOf(o) !== -1)
    return N;
  if (On(s, A) === Ds)
    return ht;
  if (qr.get(e[s]) === _r || (a === wt || a === Ct) && qr.get(e[i]) === _r || a === xn || o === xn || a === bn || [Ae, Pr, Oe].indexOf(a) === -1 && o === bn || [Qt, be, li, he, Ue].indexOf(o) !== -1 || On(s, A) === De || Fr(hr, De, s, A) || Fr([Qt, be], kr, s, A) || Fr(Dn, Dn, s, A))
    return N;
  if (a === Ae)
    return ht;
  if (a === hr || o === hr)
    return N;
  if (o === Xr || a === Xr)
    return ht;
  if ([Pr, Oe, kr].indexOf(o) !== -1 || a === ci || c === Yr && Ci.indexOf(a) !== -1 || a === Ue && o === Yr || o === Tn || JA.indexOf(o) !== -1 && a === EA || JA.indexOf(a) !== -1 && o === EA || a === Ge && [Ye, wt, Ct].indexOf(o) !== -1 || [Ye, wt, Ct].indexOf(a) !== -1 && o === Re || JA.indexOf(a) !== -1 && Sn.indexOf(o) !== -1 || Sn.indexOf(a) !== -1 && JA.indexOf(o) !== -1 || // (PR | PO) × ( OP | HY )? NU
  [Ge, Re].indexOf(a) !== -1 && (o === EA || [De, Oe].indexOf(o) !== -1 && A[i + 1] === EA) || // ( OP | HY ) × NU
  [De, Oe].indexOf(a) !== -1 && o === EA || // NU ×	(NU | SY | IS)
  a === EA && [EA, Ue, he].indexOf(o) !== -1)
    return N;
  if ([EA, Ue, he, Qt, be].indexOf(o) !== -1)
    for (var g = s; g >= 0; ) {
      var f = A[g];
      if (f === EA)
        return N;
      if ([Ue, he].indexOf(f) !== -1)
        g--;
      else
        break;
    }
  if ([Ge, Re].indexOf(o) !== -1)
    for (var g = [Qt, be].indexOf(a) !== -1 ? B : s; g >= 0; ) {
      var f = A[g];
      if (f === EA)
        return N;
      if ([Ue, he].indexOf(f) !== -1)
        g--;
      else
        break;
    }
  if (Zr === a && [Zr, Mt, Jr, Wr].indexOf(o) !== -1 || [Mt, Jr].indexOf(a) !== -1 && [Mt, Ot].indexOf(o) !== -1 || [Ot, Wr].indexOf(a) !== -1 && o === Ot || Mn.indexOf(a) !== -1 && [Tn, Re].indexOf(o) !== -1 || Mn.indexOf(o) !== -1 && a === Ge || JA.indexOf(a) !== -1 && JA.indexOf(o) !== -1 || a === he && JA.indexOf(o) !== -1 || JA.concat(EA).indexOf(a) !== -1 && o === De && Qi.indexOf(e[i]) === -1 || JA.concat(EA).indexOf(o) !== -1 && a === be)
    return N;
  if (a === Ur && o === Ur) {
    for (var H = r[s], w = 1; H > 0 && (H--, A[H] === Ur); )
      w++;
    if (w % 2 !== 0)
      return N;
  }
  return a === wt && o === Ct ? N : ht;
}, Fi = function(e, A) {
  A || (A = { lineBreak: "normal", wordBreak: "normal" });
  var r = hi(e, A.lineBreak), t = r[0], n = r[1], s = r[2];
  (A.wordBreak === "break-all" || A.wordBreak === "break-word") && (n = n.map(function(i) {
    return [EA, oe, Ts].indexOf(i) !== -1 ? Ye : i;
  }));
  var B = A.wordBreak === "keep-all" ? s.map(function(i, a) {
    return i && e[a] >= 19968 && e[a] <= 40959;
  }) : void 0;
  return [t, n, B];
}, di = (
  /** @class */
  (function() {
    function e(A, r, t, n) {
      this.codePoints = A, this.required = r === Ss, this.start = t, this.end = n;
    }
    return e.prototype.slice = function() {
      return nA.apply(void 0, this.codePoints.slice(this.start, this.end));
    }, e;
  })()
), pi = function(e, A) {
  var r = zt(e), t = Fi(r, A), n = t[0], s = t[1], B = t[2], i = r.length, a = 0, c = 0;
  return {
    next: function() {
      if (c >= i)
        return { done: !0, value: null };
      for (var o = N; c < i && (o = Ui(r, s, n, ++c, B)) === N; )
        ;
      if (o !== N || c === i) {
        var g = new di(r, o, a, c);
        return a = c, { value: g, done: !1 };
      }
      return { done: !0, value: null };
    }
  };
}, Ei = 1, Hi = 2, ze = 4, Rn = 8, Vt = 10, Gn = 47, Pe = 92, mi = 9, vi = 32, Ut = 34, Te = 61, Ii = 35, yi = 36, Li = 37, Ft = 39, dt = 40, Se = 41, Ki = 95, pA = 45, xi = 33, bi = 60, Di = 62, Ti = 64, Si = 91, Mi = 93, Oi = 61, Ri = 123, pt = 63, Gi = 125, Vn = 124, Vi = 126, Ni = 128, Nn = 65533, dr = 42, ce = 43, _i = 44, Pi = 58, Xi = 59, Ze = 46, ki = 0, Ji = 8, Wi = 11, Yi = 14, Zi = 31, qi = 127, GA = -1, Os = 48, Rs = 97, Gs = 101, zi = 102, ji = 117, $i = 122, Vs = 65, Ns = 69, _s = 70, Aa = 85, ea = 90, QA = function(e) {
  return e >= Os && e <= 57;
}, ta = function(e) {
  return e >= 55296 && e <= 57343;
}, Fe = function(e) {
  return QA(e) || e >= Vs && e <= _s || e >= Rs && e <= zi;
}, ra = function(e) {
  return e >= Rs && e <= $i;
}, na = function(e) {
  return e >= Vs && e <= ea;
}, sa = function(e) {
  return ra(e) || na(e);
}, Ba = function(e) {
  return e >= Ni;
}, Et = function(e) {
  return e === Vt || e === mi || e === vi;
}, Nt = function(e) {
  return sa(e) || Ba(e) || e === Ki;
}, _n = function(e) {
  return Nt(e) || QA(e) || e === pA;
}, ia = function(e) {
  return e >= ki && e <= Ji || e === Wi || e >= Yi && e <= Zi || e === qi;
}, $A = function(e, A) {
  return e !== Pe ? !1 : A !== Vt;
}, Ht = function(e, A, r) {
  return e === pA ? Nt(A) || $A(A, r) : Nt(e) ? !0 : !!(e === Pe && $A(e, A));
}, pr = function(e, A, r) {
  return e === ce || e === pA ? QA(A) ? !0 : A === Ze && QA(r) : QA(e === Ze ? A : e);
}, aa = function(e) {
  var A = 0, r = 1;
  (e[A] === ce || e[A] === pA) && (e[A] === pA && (r = -1), A++);
  for (var t = []; QA(e[A]); )
    t.push(e[A++]);
  var n = t.length ? parseInt(nA.apply(void 0, t), 10) : 0;
  e[A] === Ze && A++;
  for (var s = []; QA(e[A]); )
    s.push(e[A++]);
  var B = s.length, i = B ? parseInt(nA.apply(void 0, s), 10) : 0;
  (e[A] === Ns || e[A] === Gs) && A++;
  var a = 1;
  (e[A] === ce || e[A] === pA) && (e[A] === pA && (a = -1), A++);
  for (var c = []; QA(e[A]); )
    c.push(e[A++]);
  var o = c.length ? parseInt(nA.apply(void 0, c), 10) : 0;
  return r * (n + i * Math.pow(10, -B)) * Math.pow(10, a * o);
}, oa = {
  type: 2
  /* LEFT_PARENTHESIS_TOKEN */
}, ca = {
  type: 3
  /* RIGHT_PARENTHESIS_TOKEN */
}, la = {
  type: 4
  /* COMMA_TOKEN */
}, ua = {
  type: 13
  /* SUFFIX_MATCH_TOKEN */
}, ga = {
  type: 8
  /* PREFIX_MATCH_TOKEN */
}, fa = {
  type: 21
  /* COLUMN_TOKEN */
}, Qa = {
  type: 9
  /* DASH_MATCH_TOKEN */
}, wa = {
  type: 10
  /* INCLUDE_MATCH_TOKEN */
}, Ca = {
  type: 11
  /* LEFT_CURLY_BRACKET_TOKEN */
}, ha = {
  type: 12
  /* RIGHT_CURLY_BRACKET_TOKEN */
}, Ua = {
  type: 14
  /* SUBSTRING_MATCH_TOKEN */
}, mt = {
  type: 23
  /* BAD_URL_TOKEN */
}, Fa = {
  type: 1
  /* BAD_STRING_TOKEN */
}, da = {
  type: 25
  /* CDO_TOKEN */
}, pa = {
  type: 24
  /* CDC_TOKEN */
}, Ea = {
  type: 26
  /* COLON_TOKEN */
}, Ha = {
  type: 27
  /* SEMICOLON_TOKEN */
}, ma = {
  type: 28
  /* LEFT_SQUARE_BRACKET_TOKEN */
}, va = {
  type: 29
  /* RIGHT_SQUARE_BRACKET_TOKEN */
}, Ia = {
  type: 31
  /* WHITESPACE_TOKEN */
}, jr = {
  type: 32
  /* EOF_TOKEN */
}, Ps = (
  /** @class */
  (function() {
    function e() {
      this._value = [];
    }
    return e.prototype.write = function(A) {
      this._value = this._value.concat(zt(A));
    }, e.prototype.read = function() {
      for (var A = [], r = this.consumeToken(); r !== jr; )
        A.push(r), r = this.consumeToken();
      return A;
    }, e.prototype.consumeToken = function() {
      var A = this.consumeCodePoint();
      switch (A) {
        case Ut:
          return this.consumeStringToken(Ut);
        case Ii:
          var r = this.peekCodePoint(0), t = this.peekCodePoint(1), n = this.peekCodePoint(2);
          if (_n(r) || $A(t, n)) {
            var s = Ht(r, t, n) ? Hi : Ei, B = this.consumeName();
            return { type: 5, value: B, flags: s };
          }
          break;
        case yi:
          if (this.peekCodePoint(0) === Te)
            return this.consumeCodePoint(), ua;
          break;
        case Ft:
          return this.consumeStringToken(Ft);
        case dt:
          return oa;
        case Se:
          return ca;
        case dr:
          if (this.peekCodePoint(0) === Te)
            return this.consumeCodePoint(), Ua;
          break;
        case ce:
          if (pr(A, this.peekCodePoint(0), this.peekCodePoint(1)))
            return this.reconsumeCodePoint(A), this.consumeNumericToken();
          break;
        case _i:
          return la;
        case pA:
          var i = A, a = this.peekCodePoint(0), c = this.peekCodePoint(1);
          if (pr(i, a, c))
            return this.reconsumeCodePoint(A), this.consumeNumericToken();
          if (Ht(i, a, c))
            return this.reconsumeCodePoint(A), this.consumeIdentLikeToken();
          if (a === pA && c === Di)
            return this.consumeCodePoint(), this.consumeCodePoint(), pa;
          break;
        case Ze:
          if (pr(A, this.peekCodePoint(0), this.peekCodePoint(1)))
            return this.reconsumeCodePoint(A), this.consumeNumericToken();
          break;
        case Gn:
          if (this.peekCodePoint(0) === dr)
            for (this.consumeCodePoint(); ; ) {
              var o = this.consumeCodePoint();
              if (o === dr && (o = this.consumeCodePoint(), o === Gn))
                return this.consumeToken();
              if (o === GA)
                return this.consumeToken();
            }
          break;
        case Pi:
          return Ea;
        case Xi:
          return Ha;
        case bi:
          if (this.peekCodePoint(0) === xi && this.peekCodePoint(1) === pA && this.peekCodePoint(2) === pA)
            return this.consumeCodePoint(), this.consumeCodePoint(), da;
          break;
        case Ti:
          var g = this.peekCodePoint(0), f = this.peekCodePoint(1), H = this.peekCodePoint(2);
          if (Ht(g, f, H)) {
            var B = this.consumeName();
            return { type: 7, value: B };
          }
          break;
        case Si:
          return ma;
        case Pe:
          if ($A(A, this.peekCodePoint(0)))
            return this.reconsumeCodePoint(A), this.consumeIdentLikeToken();
          break;
        case Mi:
          return va;
        case Oi:
          if (this.peekCodePoint(0) === Te)
            return this.consumeCodePoint(), ga;
          break;
        case Ri:
          return Ca;
        case Gi:
          return ha;
        case ji:
        case Aa:
          var w = this.peekCodePoint(0), F = this.peekCodePoint(1);
          return w === ce && (Fe(F) || F === pt) && (this.consumeCodePoint(), this.consumeUnicodeRangeToken()), this.reconsumeCodePoint(A), this.consumeIdentLikeToken();
        case Vn:
          if (this.peekCodePoint(0) === Te)
            return this.consumeCodePoint(), Qa;
          if (this.peekCodePoint(0) === Vn)
            return this.consumeCodePoint(), fa;
          break;
        case Vi:
          if (this.peekCodePoint(0) === Te)
            return this.consumeCodePoint(), wa;
          break;
        case GA:
          return jr;
      }
      return Et(A) ? (this.consumeWhiteSpace(), Ia) : QA(A) ? (this.reconsumeCodePoint(A), this.consumeNumericToken()) : Nt(A) ? (this.reconsumeCodePoint(A), this.consumeIdentLikeToken()) : { type: 6, value: nA(A) };
    }, e.prototype.consumeCodePoint = function() {
      var A = this._value.shift();
      return typeof A > "u" ? -1 : A;
    }, e.prototype.reconsumeCodePoint = function(A) {
      this._value.unshift(A);
    }, e.prototype.peekCodePoint = function(A) {
      return A >= this._value.length ? -1 : this._value[A];
    }, e.prototype.consumeUnicodeRangeToken = function() {
      for (var A = [], r = this.consumeCodePoint(); Fe(r) && A.length < 6; )
        A.push(r), r = this.consumeCodePoint();
      for (var t = !1; r === pt && A.length < 6; )
        A.push(r), r = this.consumeCodePoint(), t = !0;
      if (t) {
        var n = parseInt(nA.apply(void 0, A.map(function(a) {
          return a === pt ? Os : a;
        })), 16), s = parseInt(nA.apply(void 0, A.map(function(a) {
          return a === pt ? _s : a;
        })), 16);
        return { type: 30, start: n, end: s };
      }
      var B = parseInt(nA.apply(void 0, A), 16);
      if (this.peekCodePoint(0) === pA && Fe(this.peekCodePoint(1))) {
        this.consumeCodePoint(), r = this.consumeCodePoint();
        for (var i = []; Fe(r) && i.length < 6; )
          i.push(r), r = this.consumeCodePoint();
        var s = parseInt(nA.apply(void 0, i), 16);
        return { type: 30, start: B, end: s };
      } else
        return { type: 30, start: B, end: B };
    }, e.prototype.consumeIdentLikeToken = function() {
      var A = this.consumeName();
      return A.toLowerCase() === "url" && this.peekCodePoint(0) === dt ? (this.consumeCodePoint(), this.consumeUrlToken()) : this.peekCodePoint(0) === dt ? (this.consumeCodePoint(), { type: 19, value: A }) : { type: 20, value: A };
    }, e.prototype.consumeUrlToken = function() {
      var A = [];
      if (this.consumeWhiteSpace(), this.peekCodePoint(0) === GA)
        return { type: 22, value: "" };
      var r = this.peekCodePoint(0);
      if (r === Ft || r === Ut) {
        var t = this.consumeStringToken(this.consumeCodePoint());
        return t.type === 0 && (this.consumeWhiteSpace(), this.peekCodePoint(0) === GA || this.peekCodePoint(0) === Se) ? (this.consumeCodePoint(), { type: 22, value: t.value }) : (this.consumeBadUrlRemnants(), mt);
      }
      for (; ; ) {
        var n = this.consumeCodePoint();
        if (n === GA || n === Se)
          return { type: 22, value: nA.apply(void 0, A) };
        if (Et(n))
          return this.consumeWhiteSpace(), this.peekCodePoint(0) === GA || this.peekCodePoint(0) === Se ? (this.consumeCodePoint(), { type: 22, value: nA.apply(void 0, A) }) : (this.consumeBadUrlRemnants(), mt);
        if (n === Ut || n === Ft || n === dt || ia(n))
          return this.consumeBadUrlRemnants(), mt;
        if (n === Pe)
          if ($A(n, this.peekCodePoint(0)))
            A.push(this.consumeEscapedCodePoint());
          else
            return this.consumeBadUrlRemnants(), mt;
        else
          A.push(n);
      }
    }, e.prototype.consumeWhiteSpace = function() {
      for (; Et(this.peekCodePoint(0)); )
        this.consumeCodePoint();
    }, e.prototype.consumeBadUrlRemnants = function() {
      for (; ; ) {
        var A = this.consumeCodePoint();
        if (A === Se || A === GA)
          return;
        $A(A, this.peekCodePoint(0)) && this.consumeEscapedCodePoint();
      }
    }, e.prototype.consumeStringSlice = function(A) {
      for (var r = 5e4, t = ""; A > 0; ) {
        var n = Math.min(r, A);
        t += nA.apply(void 0, this._value.splice(0, n)), A -= n;
      }
      return this._value.shift(), t;
    }, e.prototype.consumeStringToken = function(A) {
      var r = "", t = 0;
      do {
        var n = this._value[t];
        if (n === GA || n === void 0 || n === A)
          return r += this.consumeStringSlice(t), { type: 0, value: r };
        if (n === Vt)
          return this._value.splice(0, t), Fa;
        if (n === Pe) {
          var s = this._value[t + 1];
          s !== GA && s !== void 0 && (s === Vt ? (r += this.consumeStringSlice(t), t = -1, this._value.shift()) : $A(n, s) && (r += this.consumeStringSlice(t), r += nA(this.consumeEscapedCodePoint()), t = -1));
        }
        t++;
      } while (!0);
    }, e.prototype.consumeNumber = function() {
      var A = [], r = ze, t = this.peekCodePoint(0);
      for ((t === ce || t === pA) && A.push(this.consumeCodePoint()); QA(this.peekCodePoint(0)); )
        A.push(this.consumeCodePoint());
      t = this.peekCodePoint(0);
      var n = this.peekCodePoint(1);
      if (t === Ze && QA(n))
        for (A.push(this.consumeCodePoint(), this.consumeCodePoint()), r = Rn; QA(this.peekCodePoint(0)); )
          A.push(this.consumeCodePoint());
      t = this.peekCodePoint(0), n = this.peekCodePoint(1);
      var s = this.peekCodePoint(2);
      if ((t === Ns || t === Gs) && ((n === ce || n === pA) && QA(s) || QA(n)))
        for (A.push(this.consumeCodePoint(), this.consumeCodePoint()), r = Rn; QA(this.peekCodePoint(0)); )
          A.push(this.consumeCodePoint());
      return [aa(A), r];
    }, e.prototype.consumeNumericToken = function() {
      var A = this.consumeNumber(), r = A[0], t = A[1], n = this.peekCodePoint(0), s = this.peekCodePoint(1), B = this.peekCodePoint(2);
      if (Ht(n, s, B)) {
        var i = this.consumeName();
        return { type: 15, number: r, flags: t, unit: i };
      }
      return n === Li ? (this.consumeCodePoint(), { type: 16, number: r, flags: t }) : { type: 17, number: r, flags: t };
    }, e.prototype.consumeEscapedCodePoint = function() {
      var A = this.consumeCodePoint();
      if (Fe(A)) {
        for (var r = nA(A); Fe(this.peekCodePoint(0)) && r.length < 6; )
          r += nA(this.consumeCodePoint());
        Et(this.peekCodePoint(0)) && this.consumeCodePoint();
        var t = parseInt(r, 16);
        return t === 0 || ta(t) || t > 1114111 ? Nn : t;
      }
      return A === GA ? Nn : A;
    }, e.prototype.consumeName = function() {
      for (var A = ""; ; ) {
        var r = this.consumeCodePoint();
        if (_n(r))
          A += nA(r);
        else if ($A(r, this.peekCodePoint(0)))
          A += nA(this.consumeEscapedCodePoint());
        else
          return this.reconsumeCodePoint(r), A;
      }
    }, e;
  })()
), Xs = (
  /** @class */
  (function() {
    function e(A) {
      this._tokens = A;
    }
    return e.create = function(A) {
      var r = new Ps();
      return r.write(A), new e(r.read());
    }, e.parseValue = function(A) {
      return e.create(A).parseComponentValue();
    }, e.parseValues = function(A) {
      return e.create(A).parseComponentValues();
    }, e.prototype.parseComponentValue = function() {
      for (var A = this.consumeToken(); A.type === 31; )
        A = this.consumeToken();
      if (A.type === 32)
        throw new SyntaxError("Error parsing CSS component value, unexpected EOF");
      this.reconsumeToken(A);
      var r = this.consumeComponentValue();
      do
        A = this.consumeToken();
      while (A.type === 31);
      if (A.type === 32)
        return r;
      throw new SyntaxError("Error parsing CSS component value, multiple values found when expecting only one");
    }, e.prototype.parseComponentValues = function() {
      for (var A = []; ; ) {
        var r = this.consumeComponentValue();
        if (r.type === 32)
          return A;
        A.push(r), A.push();
      }
    }, e.prototype.consumeComponentValue = function() {
      var A = this.consumeToken();
      switch (A.type) {
        case 11:
        case 28:
        case 2:
          return this.consumeSimpleBlock(A.type);
        case 19:
          return this.consumeFunction(A);
      }
      return A;
    }, e.prototype.consumeSimpleBlock = function(A) {
      for (var r = { type: A, values: [] }, t = this.consumeToken(); ; ) {
        if (t.type === 32 || La(t, A))
          return r;
        this.reconsumeToken(t), r.values.push(this.consumeComponentValue()), t = this.consumeToken();
      }
    }, e.prototype.consumeFunction = function(A) {
      for (var r = {
        name: A.value,
        values: [],
        type: 18
        /* FUNCTION */
      }; ; ) {
        var t = this.consumeToken();
        if (t.type === 32 || t.type === 3)
          return r;
        this.reconsumeToken(t), r.values.push(this.consumeComponentValue());
      }
    }, e.prototype.consumeToken = function() {
      var A = this._tokens.shift();
      return typeof A > "u" ? jr : A;
    }, e.prototype.reconsumeToken = function(A) {
      this._tokens.unshift(A);
    }, e;
  })()
), je = function(e) {
  return e.type === 15;
}, Le = function(e) {
  return e.type === 17;
}, Z = function(e) {
  return e.type === 20;
}, ya = function(e) {
  return e.type === 0;
}, $r = function(e, A) {
  return Z(e) && e.value === A;
}, ks = function(e) {
  return e.type !== 31;
}, ye = function(e) {
  return e.type !== 31 && e.type !== 4;
}, NA = function(e) {
  var A = [], r = [];
  return e.forEach(function(t) {
    if (t.type === 4) {
      if (r.length === 0)
        throw new Error("Error parsing function args, zero tokens for arg");
      A.push(r), r = [];
      return;
    }
    t.type !== 31 && r.push(t);
  }), r.length && A.push(r), A;
}, La = function(e, A) {
  return A === 11 && e.type === 12 || A === 28 && e.type === 29 ? !0 : A === 2 && e.type === 3;
}, se = function(e) {
  return e.type === 17 || e.type === 15;
}, sA = function(e) {
  return e.type === 16 || se(e);
}, Js = function(e) {
  return e.length > 1 ? [e[0], e[1]] : [e[0]];
}, lA = {
  type: 17,
  number: 0,
  flags: ze
}, un = {
  type: 16,
  number: 50,
  flags: ze
}, ee = {
  type: 16,
  number: 100,
  flags: ze
}, Ve = function(e, A, r) {
  var t = e[0], n = e[1];
  return [q(t, A), q(typeof n < "u" ? n : t, r)];
}, q = function(e, A) {
  if (e.type === 16)
    return e.number / 100 * A;
  if (je(e))
    switch (e.unit) {
      case "rem":
      case "em":
        return 16 * e.number;
      // TODO use correct font-size
      case "px":
      default:
        return e.number;
    }
  return e.number;
}, Ws = "deg", Ys = "grad", Zs = "rad", qs = "turn", jt = {
  name: "angle",
  parse: function(e, A) {
    if (A.type === 15)
      switch (A.unit) {
        case Ws:
          return Math.PI * A.number / 180;
        case Ys:
          return Math.PI / 200 * A.number;
        case Zs:
          return A.number;
        case qs:
          return Math.PI * 2 * A.number;
      }
    throw new Error("Unsupported angle type");
  }
}, zs = function(e) {
  return e.type === 15 && (e.unit === Ws || e.unit === Ys || e.unit === Zs || e.unit === qs);
}, js = function(e) {
  var A = e.filter(Z).map(function(r) {
    return r.value;
  }).join(" ");
  switch (A) {
    case "to bottom right":
    case "to right bottom":
    case "left top":
    case "top left":
      return [lA, lA];
    case "to top":
    case "bottom":
      return LA(0);
    case "to bottom left":
    case "to left bottom":
    case "right top":
    case "top right":
      return [lA, ee];
    case "to right":
    case "left":
      return LA(90);
    case "to top left":
    case "to left top":
    case "right bottom":
    case "bottom right":
      return [ee, ee];
    case "to bottom":
    case "top":
      return LA(180);
    case "to top right":
    case "to right top":
    case "left bottom":
    case "bottom left":
      return [ee, lA];
    case "to left":
    case "right":
      return LA(270);
  }
  return 0;
}, LA = function(e) {
  return Math.PI * e / 180;
}, re = {
  name: "color",
  parse: function(e, A) {
    if (A.type === 18) {
      var r = Ka[A.name];
      if (typeof r > "u")
        throw new Error('Attempting to parse an unsupported color function "' + A.name + '"');
      return r(e, A.values);
    }
    if (A.type === 5) {
      if (A.value.length === 3) {
        var t = A.value.substring(0, 1), n = A.value.substring(1, 2), s = A.value.substring(2, 3);
        return te(parseInt(t + t, 16), parseInt(n + n, 16), parseInt(s + s, 16), 1);
      }
      if (A.value.length === 4) {
        var t = A.value.substring(0, 1), n = A.value.substring(1, 2), s = A.value.substring(2, 3), B = A.value.substring(3, 4);
        return te(parseInt(t + t, 16), parseInt(n + n, 16), parseInt(s + s, 16), parseInt(B + B, 16) / 255);
      }
      if (A.value.length === 6) {
        var t = A.value.substring(0, 2), n = A.value.substring(2, 4), s = A.value.substring(4, 6);
        return te(parseInt(t, 16), parseInt(n, 16), parseInt(s, 16), 1);
      }
      if (A.value.length === 8) {
        var t = A.value.substring(0, 2), n = A.value.substring(2, 4), s = A.value.substring(4, 6), B = A.value.substring(6, 8);
        return te(parseInt(t, 16), parseInt(n, 16), parseInt(s, 16), parseInt(B, 16) / 255);
      }
    }
    if (A.type === 20) {
      var i = YA[A.value.toUpperCase()];
      if (typeof i < "u")
        return i;
    }
    return YA.TRANSPARENT;
  }
}, ne = function(e) {
  return (255 & e) === 0;
}, oA = function(e) {
  var A = 255 & e, r = 255 & e >> 8, t = 255 & e >> 16, n = 255 & e >> 24;
  return A < 255 ? "rgba(" + n + "," + t + "," + r + "," + A / 255 + ")" : "rgb(" + n + "," + t + "," + r + ")";
}, te = function(e, A, r, t) {
  return (e << 24 | A << 16 | r << 8 | Math.round(t * 255) << 0) >>> 0;
}, Pn = function(e, A) {
  if (e.type === 17)
    return e.number;
  if (e.type === 16) {
    var r = A === 3 ? 1 : 255;
    return A === 3 ? e.number / 100 * r : Math.round(e.number / 100 * r);
  }
  return 0;
}, Xn = function(e, A) {
  var r = A.filter(ye);
  if (r.length === 3) {
    var t = r.map(Pn), n = t[0], s = t[1], B = t[2];
    return te(n, s, B, 1);
  }
  if (r.length === 4) {
    var i = r.map(Pn), n = i[0], s = i[1], B = i[2], a = i[3];
    return te(n, s, B, a);
  }
  return 0;
};
function Er(e, A, r) {
  return r < 0 && (r += 1), r >= 1 && (r -= 1), r < 1 / 6 ? (A - e) * r * 6 + e : r < 1 / 2 ? A : r < 2 / 3 ? (A - e) * 6 * (2 / 3 - r) + e : e;
}
var kn = function(e, A) {
  var r = A.filter(ye), t = r[0], n = r[1], s = r[2], B = r[3], i = (t.type === 17 ? LA(t.number) : jt.parse(e, t)) / (Math.PI * 2), a = sA(n) ? n.number / 100 : 0, c = sA(s) ? s.number / 100 : 0, o = typeof B < "u" && sA(B) ? q(B, 1) : 1;
  if (a === 0)
    return te(c * 255, c * 255, c * 255, 1);
  var g = c <= 0.5 ? c * (a + 1) : c + a - c * a, f = c * 2 - g, H = Er(f, g, i + 1 / 3), w = Er(f, g, i), F = Er(f, g, i - 1 / 3);
  return te(H * 255, w * 255, F * 255, o);
}, Ka = {
  hsl: kn,
  hsla: kn,
  rgb: Xn,
  rgba: Xn
}, Xe = function(e, A) {
  return re.parse(e, Xs.create(A).parseComponentValue());
}, YA = {
  ALICEBLUE: 4042850303,
  ANTIQUEWHITE: 4209760255,
  AQUA: 16777215,
  AQUAMARINE: 2147472639,
  AZURE: 4043309055,
  BEIGE: 4126530815,
  BISQUE: 4293182719,
  BLACK: 255,
  BLANCHEDALMOND: 4293643775,
  BLUE: 65535,
  BLUEVIOLET: 2318131967,
  BROWN: 2771004159,
  BURLYWOOD: 3736635391,
  CADETBLUE: 1604231423,
  CHARTREUSE: 2147418367,
  CHOCOLATE: 3530104575,
  CORAL: 4286533887,
  CORNFLOWERBLUE: 1687547391,
  CORNSILK: 4294499583,
  CRIMSON: 3692313855,
  CYAN: 16777215,
  DARKBLUE: 35839,
  DARKCYAN: 9145343,
  DARKGOLDENROD: 3095837695,
  DARKGRAY: 2846468607,
  DARKGREEN: 6553855,
  DARKGREY: 2846468607,
  DARKKHAKI: 3182914559,
  DARKMAGENTA: 2332068863,
  DARKOLIVEGREEN: 1433087999,
  DARKORANGE: 4287365375,
  DARKORCHID: 2570243327,
  DARKRED: 2332033279,
  DARKSALMON: 3918953215,
  DARKSEAGREEN: 2411499519,
  DARKSLATEBLUE: 1211993087,
  DARKSLATEGRAY: 793726975,
  DARKSLATEGREY: 793726975,
  DARKTURQUOISE: 13554175,
  DARKVIOLET: 2483082239,
  DEEPPINK: 4279538687,
  DEEPSKYBLUE: 12582911,
  DIMGRAY: 1768516095,
  DIMGREY: 1768516095,
  DODGERBLUE: 512819199,
  FIREBRICK: 2988581631,
  FLORALWHITE: 4294635775,
  FORESTGREEN: 579543807,
  FUCHSIA: 4278255615,
  GAINSBORO: 3705462015,
  GHOSTWHITE: 4177068031,
  GOLD: 4292280575,
  GOLDENROD: 3668254975,
  GRAY: 2155905279,
  GREEN: 8388863,
  GREENYELLOW: 2919182335,
  GREY: 2155905279,
  HONEYDEW: 4043305215,
  HOTPINK: 4285117695,
  INDIANRED: 3445382399,
  INDIGO: 1258324735,
  IVORY: 4294963455,
  KHAKI: 4041641215,
  LAVENDER: 3873897215,
  LAVENDERBLUSH: 4293981695,
  LAWNGREEN: 2096890111,
  LEMONCHIFFON: 4294626815,
  LIGHTBLUE: 2916673279,
  LIGHTCORAL: 4034953471,
  LIGHTCYAN: 3774873599,
  LIGHTGOLDENRODYELLOW: 4210742015,
  LIGHTGRAY: 3553874943,
  LIGHTGREEN: 2431553791,
  LIGHTGREY: 3553874943,
  LIGHTPINK: 4290167295,
  LIGHTSALMON: 4288707327,
  LIGHTSEAGREEN: 548580095,
  LIGHTSKYBLUE: 2278488831,
  LIGHTSLATEGRAY: 2005441023,
  LIGHTSLATEGREY: 2005441023,
  LIGHTSTEELBLUE: 2965692159,
  LIGHTYELLOW: 4294959359,
  LIME: 16711935,
  LIMEGREEN: 852308735,
  LINEN: 4210091775,
  MAGENTA: 4278255615,
  MAROON: 2147483903,
  MEDIUMAQUAMARINE: 1724754687,
  MEDIUMBLUE: 52735,
  MEDIUMORCHID: 3126187007,
  MEDIUMPURPLE: 2473647103,
  MEDIUMSEAGREEN: 1018393087,
  MEDIUMSLATEBLUE: 2070474495,
  MEDIUMSPRINGGREEN: 16423679,
  MEDIUMTURQUOISE: 1221709055,
  MEDIUMVIOLETRED: 3340076543,
  MIDNIGHTBLUE: 421097727,
  MINTCREAM: 4127193855,
  MISTYROSE: 4293190143,
  MOCCASIN: 4293178879,
  NAVAJOWHITE: 4292783615,
  NAVY: 33023,
  OLDLACE: 4260751103,
  OLIVE: 2155872511,
  OLIVEDRAB: 1804477439,
  ORANGE: 4289003775,
  ORANGERED: 4282712319,
  ORCHID: 3664828159,
  PALEGOLDENROD: 4008225535,
  PALEGREEN: 2566625535,
  PALETURQUOISE: 2951671551,
  PALEVIOLETRED: 3681588223,
  PAPAYAWHIP: 4293907967,
  PEACHPUFF: 4292524543,
  PERU: 3448061951,
  PINK: 4290825215,
  PLUM: 3718307327,
  POWDERBLUE: 2967529215,
  PURPLE: 2147516671,
  REBECCAPURPLE: 1714657791,
  RED: 4278190335,
  ROSYBROWN: 3163525119,
  ROYALBLUE: 1097458175,
  SADDLEBROWN: 2336560127,
  SALMON: 4202722047,
  SANDYBROWN: 4104413439,
  SEAGREEN: 780883967,
  SEASHELL: 4294307583,
  SIENNA: 2689740287,
  SILVER: 3233857791,
  SKYBLUE: 2278484991,
  SLATEBLUE: 1784335871,
  SLATEGRAY: 1887473919,
  SLATEGREY: 1887473919,
  SNOW: 4294638335,
  SPRINGGREEN: 16744447,
  STEELBLUE: 1182971135,
  TAN: 3535047935,
  TEAL: 8421631,
  THISTLE: 3636451583,
  TOMATO: 4284696575,
  TRANSPARENT: 0,
  TURQUOISE: 1088475391,
  VIOLET: 4001558271,
  WHEAT: 4125012991,
  WHITE: 4294967295,
  WHITESMOKE: 4126537215,
  YELLOW: 4294902015,
  YELLOWGREEN: 2597139199
}, xa = {
  name: "background-clip",
  initialValue: "border-box",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    return A.map(function(r) {
      if (Z(r))
        switch (r.value) {
          case "padding-box":
            return 1;
          case "content-box":
            return 2;
        }
      return 0;
    });
  }
}, ba = {
  name: "background-color",
  initialValue: "transparent",
  prefix: !1,
  type: 3,
  format: "color"
}, $t = function(e, A) {
  var r = re.parse(e, A[0]), t = A[1];
  return t && sA(t) ? { color: r, stop: t } : { color: r, stop: null };
}, Jn = function(e, A) {
  var r = e[0], t = e[e.length - 1];
  r.stop === null && (r.stop = lA), t.stop === null && (t.stop = ee);
  for (var n = [], s = 0, B = 0; B < e.length; B++) {
    var i = e[B].stop;
    if (i !== null) {
      var a = q(i, A);
      a > s ? n.push(a) : n.push(s), s = a;
    } else
      n.push(null);
  }
  for (var c = null, B = 0; B < n.length; B++) {
    var o = n[B];
    if (o === null)
      c === null && (c = B);
    else if (c !== null) {
      for (var g = B - c, f = n[c - 1], H = (o - f) / (g + 1), w = 1; w <= g; w++)
        n[c + w - 1] = H * w;
      c = null;
    }
  }
  return e.map(function(F, b) {
    var K = F.color;
    return { color: K, stop: Math.max(Math.min(1, n[b] / A), 0) };
  });
}, Da = function(e, A, r) {
  var t = A / 2, n = r / 2, s = q(e[0], A) - t, B = n - q(e[1], r);
  return (Math.atan2(B, s) + Math.PI * 2) % (Math.PI * 2);
}, Ta = function(e, A, r) {
  var t = typeof e == "number" ? e : Da(e, A, r), n = Math.abs(A * Math.sin(t)) + Math.abs(r * Math.cos(t)), s = A / 2, B = r / 2, i = n / 2, a = Math.sin(t - Math.PI / 2) * i, c = Math.cos(t - Math.PI / 2) * i;
  return [n, s - c, s + c, B - a, B + a];
}, SA = function(e, A) {
  return Math.sqrt(e * e + A * A);
}, Wn = function(e, A, r, t, n) {
  var s = [
    [0, 0],
    [0, A],
    [e, 0],
    [e, A]
  ];
  return s.reduce(function(B, i) {
    var a = i[0], c = i[1], o = SA(r - a, t - c);
    return (n ? o < B.optimumDistance : o > B.optimumDistance) ? {
      optimumCorner: i,
      optimumDistance: o
    } : B;
  }, {
    optimumDistance: n ? 1 / 0 : -1 / 0,
    optimumCorner: null
  }).optimumCorner;
}, Sa = function(e, A, r, t, n) {
  var s = 0, B = 0;
  switch (e.size) {
    case 0:
      e.shape === 0 ? s = B = Math.min(Math.abs(A), Math.abs(A - t), Math.abs(r), Math.abs(r - n)) : e.shape === 1 && (s = Math.min(Math.abs(A), Math.abs(A - t)), B = Math.min(Math.abs(r), Math.abs(r - n)));
      break;
    case 2:
      if (e.shape === 0)
        s = B = Math.min(SA(A, r), SA(A, r - n), SA(A - t, r), SA(A - t, r - n));
      else if (e.shape === 1) {
        var i = Math.min(Math.abs(r), Math.abs(r - n)) / Math.min(Math.abs(A), Math.abs(A - t)), a = Wn(t, n, A, r, !0), c = a[0], o = a[1];
        s = SA(c - A, (o - r) / i), B = i * s;
      }
      break;
    case 1:
      e.shape === 0 ? s = B = Math.max(Math.abs(A), Math.abs(A - t), Math.abs(r), Math.abs(r - n)) : e.shape === 1 && (s = Math.max(Math.abs(A), Math.abs(A - t)), B = Math.max(Math.abs(r), Math.abs(r - n)));
      break;
    case 3:
      if (e.shape === 0)
        s = B = Math.max(SA(A, r), SA(A, r - n), SA(A - t, r), SA(A - t, r - n));
      else if (e.shape === 1) {
        var i = Math.max(Math.abs(r), Math.abs(r - n)) / Math.max(Math.abs(A), Math.abs(A - t)), g = Wn(t, n, A, r, !1), c = g[0], o = g[1];
        s = SA(c - A, (o - r) / i), B = i * s;
      }
      break;
  }
  return Array.isArray(e.size) && (s = q(e.size[0], t), B = e.size.length === 2 ? q(e.size[1], n) : s), [s, B];
}, Ma = function(e, A) {
  var r = LA(180), t = [];
  return NA(A).forEach(function(n, s) {
    if (s === 0) {
      var B = n[0];
      if (B.type === 20 && B.value === "to") {
        r = js(n);
        return;
      } else if (zs(B)) {
        r = jt.parse(e, B);
        return;
      }
    }
    var i = $t(e, n);
    t.push(i);
  }), {
    angle: r,
    stops: t,
    type: 1
    /* LINEAR_GRADIENT */
  };
}, vt = function(e, A) {
  var r = LA(180), t = [];
  return NA(A).forEach(function(n, s) {
    if (s === 0) {
      var B = n[0];
      if (B.type === 20 && ["top", "left", "right", "bottom"].indexOf(B.value) !== -1) {
        r = js(n);
        return;
      } else if (zs(B)) {
        r = (jt.parse(e, B) + LA(270)) % LA(360);
        return;
      }
    }
    var i = $t(e, n);
    t.push(i);
  }), {
    angle: r,
    stops: t,
    type: 1
    /* LINEAR_GRADIENT */
  };
}, Oa = function(e, A) {
  var r = LA(180), t = [], n = 1, s = 0, B = 3, i = [];
  return NA(A).forEach(function(a, c) {
    var o = a[0];
    if (c === 0) {
      if (Z(o) && o.value === "linear") {
        n = 1;
        return;
      } else if (Z(o) && o.value === "radial") {
        n = 2;
        return;
      }
    }
    if (o.type === 18) {
      if (o.name === "from") {
        var g = re.parse(e, o.values[0]);
        t.push({ stop: lA, color: g });
      } else if (o.name === "to") {
        var g = re.parse(e, o.values[0]);
        t.push({ stop: ee, color: g });
      } else if (o.name === "color-stop") {
        var f = o.values.filter(ye);
        if (f.length === 2) {
          var g = re.parse(e, f[1]), H = f[0];
          Le(H) && t.push({
            stop: { type: 16, number: H.number * 100, flags: H.flags },
            color: g
          });
        }
      }
    }
  }), n === 1 ? {
    angle: (r + LA(180)) % LA(360),
    stops: t,
    type: n
  } : { size: B, shape: s, stops: t, position: i, type: n };
}, $s = "closest-side", AB = "farthest-side", eB = "closest-corner", tB = "farthest-corner", rB = "circle", nB = "ellipse", sB = "cover", BB = "contain", Ra = function(e, A) {
  var r = 0, t = 3, n = [], s = [];
  return NA(A).forEach(function(B, i) {
    var a = !0;
    if (i === 0) {
      var c = !1;
      a = B.reduce(function(g, f) {
        if (c)
          if (Z(f))
            switch (f.value) {
              case "center":
                return s.push(un), g;
              case "top":
              case "left":
                return s.push(lA), g;
              case "right":
              case "bottom":
                return s.push(ee), g;
            }
          else (sA(f) || se(f)) && s.push(f);
        else if (Z(f))
          switch (f.value) {
            case rB:
              return r = 0, !1;
            case nB:
              return r = 1, !1;
            case "at":
              return c = !0, !1;
            case $s:
              return t = 0, !1;
            case sB:
            case AB:
              return t = 1, !1;
            case BB:
            case eB:
              return t = 2, !1;
            case tB:
              return t = 3, !1;
          }
        else if (se(f) || sA(f))
          return Array.isArray(t) || (t = []), t.push(f), !1;
        return g;
      }, a);
    }
    if (a) {
      var o = $t(e, B);
      n.push(o);
    }
  }), {
    size: t,
    shape: r,
    stops: n,
    position: s,
    type: 2
    /* RADIAL_GRADIENT */
  };
}, It = function(e, A) {
  var r = 0, t = 3, n = [], s = [];
  return NA(A).forEach(function(B, i) {
    var a = !0;
    if (i === 0 ? a = B.reduce(function(o, g) {
      if (Z(g))
        switch (g.value) {
          case "center":
            return s.push(un), !1;
          case "top":
          case "left":
            return s.push(lA), !1;
          case "right":
          case "bottom":
            return s.push(ee), !1;
        }
      else if (sA(g) || se(g))
        return s.push(g), !1;
      return o;
    }, a) : i === 1 && (a = B.reduce(function(o, g) {
      if (Z(g))
        switch (g.value) {
          case rB:
            return r = 0, !1;
          case nB:
            return r = 1, !1;
          case BB:
          case $s:
            return t = 0, !1;
          case AB:
            return t = 1, !1;
          case eB:
            return t = 2, !1;
          case sB:
          case tB:
            return t = 3, !1;
        }
      else if (se(g) || sA(g))
        return Array.isArray(t) || (t = []), t.push(g), !1;
      return o;
    }, a)), a) {
      var c = $t(e, B);
      n.push(c);
    }
  }), {
    size: t,
    shape: r,
    stops: n,
    position: s,
    type: 2
    /* RADIAL_GRADIENT */
  };
}, Ga = function(e) {
  return e.type === 1;
}, Va = function(e) {
  return e.type === 2;
}, gn = {
  name: "image",
  parse: function(e, A) {
    if (A.type === 22) {
      var r = {
        url: A.value,
        type: 0
        /* URL */
      };
      return e.cache.addImage(A.value), r;
    }
    if (A.type === 18) {
      var t = iB[A.name];
      if (typeof t > "u")
        throw new Error('Attempting to parse an unsupported image function "' + A.name + '"');
      return t(e, A.values);
    }
    throw new Error("Unsupported image type " + A.type);
  }
};
function Na(e) {
  return !(e.type === 20 && e.value === "none") && (e.type !== 18 || !!iB[e.name]);
}
var iB = {
  "linear-gradient": Ma,
  "-moz-linear-gradient": vt,
  "-ms-linear-gradient": vt,
  "-o-linear-gradient": vt,
  "-webkit-linear-gradient": vt,
  "radial-gradient": Ra,
  "-moz-radial-gradient": It,
  "-ms-radial-gradient": It,
  "-o-radial-gradient": It,
  "-webkit-radial-gradient": It,
  "-webkit-gradient": Oa
}, _a = {
  name: "background-image",
  initialValue: "none",
  type: 1,
  prefix: !1,
  parse: function(e, A) {
    if (A.length === 0)
      return [];
    var r = A[0];
    return r.type === 20 && r.value === "none" ? [] : A.filter(function(t) {
      return ye(t) && Na(t);
    }).map(function(t) {
      return gn.parse(e, t);
    });
  }
}, Pa = {
  name: "background-origin",
  initialValue: "border-box",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    return A.map(function(r) {
      if (Z(r))
        switch (r.value) {
          case "padding-box":
            return 1;
          case "content-box":
            return 2;
        }
      return 0;
    });
  }
}, Xa = {
  name: "background-position",
  initialValue: "0% 0%",
  type: 1,
  prefix: !1,
  parse: function(e, A) {
    return NA(A).map(function(r) {
      return r.filter(sA);
    }).map(Js);
  }
}, ka = {
  name: "background-repeat",
  initialValue: "repeat",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    return NA(A).map(function(r) {
      return r.filter(Z).map(function(t) {
        return t.value;
      }).join(" ");
    }).map(Ja);
  }
}, Ja = function(e) {
  switch (e) {
    case "no-repeat":
      return 1;
    case "repeat-x":
    case "repeat no-repeat":
      return 2;
    case "repeat-y":
    case "no-repeat repeat":
      return 3;
    case "repeat":
    default:
      return 0;
  }
}, Ie;
(function(e) {
  e.AUTO = "auto", e.CONTAIN = "contain", e.COVER = "cover";
})(Ie || (Ie = {}));
var Wa = {
  name: "background-size",
  initialValue: "0",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    return NA(A).map(function(r) {
      return r.filter(Ya);
    });
  }
}, Ya = function(e) {
  return Z(e) || sA(e);
}, Ar = function(e) {
  return {
    name: "border-" + e + "-color",
    initialValue: "transparent",
    prefix: !1,
    type: 3,
    format: "color"
  };
}, Za = Ar("top"), qa = Ar("right"), za = Ar("bottom"), ja = Ar("left"), er = function(e) {
  return {
    name: "border-radius-" + e,
    initialValue: "0 0",
    prefix: !1,
    type: 1,
    parse: function(A, r) {
      return Js(r.filter(sA));
    }
  };
}, $a = er("top-left"), Ao = er("top-right"), eo = er("bottom-right"), to = er("bottom-left"), tr = function(e) {
  return {
    name: "border-" + e + "-style",
    initialValue: "solid",
    prefix: !1,
    type: 2,
    parse: function(A, r) {
      switch (r) {
        case "none":
          return 0;
        case "dashed":
          return 2;
        case "dotted":
          return 3;
        case "double":
          return 4;
      }
      return 1;
    }
  };
}, ro = tr("top"), no = tr("right"), so = tr("bottom"), Bo = tr("left"), rr = function(e) {
  return {
    name: "border-" + e + "-width",
    initialValue: "0",
    type: 0,
    prefix: !1,
    parse: function(A, r) {
      return je(r) ? r.number : 0;
    }
  };
}, io = rr("top"), ao = rr("right"), oo = rr("bottom"), co = rr("left"), lo = {
  name: "color",
  initialValue: "transparent",
  prefix: !1,
  type: 3,
  format: "color"
}, uo = {
  name: "direction",
  initialValue: "ltr",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "rtl":
        return 1;
      case "ltr":
      default:
        return 0;
    }
  }
}, go = {
  name: "display",
  initialValue: "inline-block",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    return A.filter(Z).reduce(
      function(r, t) {
        return r | fo(t.value);
      },
      0
      /* NONE */
    );
  }
}, fo = function(e) {
  switch (e) {
    case "block":
    case "-webkit-box":
      return 2;
    case "inline":
      return 4;
    case "run-in":
      return 8;
    case "flow":
      return 16;
    case "flow-root":
      return 32;
    case "table":
      return 64;
    case "flex":
    case "-webkit-flex":
      return 128;
    case "grid":
    case "-ms-grid":
      return 256;
    case "ruby":
      return 512;
    case "subgrid":
      return 1024;
    case "list-item":
      return 2048;
    case "table-row-group":
      return 4096;
    case "table-header-group":
      return 8192;
    case "table-footer-group":
      return 16384;
    case "table-row":
      return 32768;
    case "table-cell":
      return 65536;
    case "table-column-group":
      return 131072;
    case "table-column":
      return 262144;
    case "table-caption":
      return 524288;
    case "ruby-base":
      return 1048576;
    case "ruby-text":
      return 2097152;
    case "ruby-base-container":
      return 4194304;
    case "ruby-text-container":
      return 8388608;
    case "contents":
      return 16777216;
    case "inline-block":
      return 33554432;
    case "inline-list-item":
      return 67108864;
    case "inline-table":
      return 134217728;
    case "inline-flex":
      return 268435456;
    case "inline-grid":
      return 536870912;
  }
  return 0;
}, Qo = {
  name: "float",
  initialValue: "none",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "left":
        return 1;
      case "right":
        return 2;
      case "inline-start":
        return 3;
      case "inline-end":
        return 4;
    }
    return 0;
  }
}, wo = {
  name: "letter-spacing",
  initialValue: "0",
  prefix: !1,
  type: 0,
  parse: function(e, A) {
    return A.type === 20 && A.value === "normal" ? 0 : A.type === 17 || A.type === 15 ? A.number : 0;
  }
}, _t;
(function(e) {
  e.NORMAL = "normal", e.STRICT = "strict";
})(_t || (_t = {}));
var Co = {
  name: "line-break",
  initialValue: "normal",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "strict":
        return _t.STRICT;
      case "normal":
      default:
        return _t.NORMAL;
    }
  }
}, ho = {
  name: "line-height",
  initialValue: "normal",
  prefix: !1,
  type: 4
  /* TOKEN_VALUE */
}, Yn = function(e, A) {
  return Z(e) && e.value === "normal" ? 1.2 * A : e.type === 17 ? A * e.number : sA(e) ? q(e, A) : A;
}, Uo = {
  name: "list-style-image",
  initialValue: "none",
  type: 0,
  prefix: !1,
  parse: function(e, A) {
    return A.type === 20 && A.value === "none" ? null : gn.parse(e, A);
  }
}, Fo = {
  name: "list-style-position",
  initialValue: "outside",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "inside":
        return 0;
      case "outside":
      default:
        return 1;
    }
  }
}, An = {
  name: "list-style-type",
  initialValue: "none",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "disc":
        return 0;
      case "circle":
        return 1;
      case "square":
        return 2;
      case "decimal":
        return 3;
      case "cjk-decimal":
        return 4;
      case "decimal-leading-zero":
        return 5;
      case "lower-roman":
        return 6;
      case "upper-roman":
        return 7;
      case "lower-greek":
        return 8;
      case "lower-alpha":
        return 9;
      case "upper-alpha":
        return 10;
      case "arabic-indic":
        return 11;
      case "armenian":
        return 12;
      case "bengali":
        return 13;
      case "cambodian":
        return 14;
      case "cjk-earthly-branch":
        return 15;
      case "cjk-heavenly-stem":
        return 16;
      case "cjk-ideographic":
        return 17;
      case "devanagari":
        return 18;
      case "ethiopic-numeric":
        return 19;
      case "georgian":
        return 20;
      case "gujarati":
        return 21;
      case "gurmukhi":
        return 22;
      case "hebrew":
        return 22;
      case "hiragana":
        return 23;
      case "hiragana-iroha":
        return 24;
      case "japanese-formal":
        return 25;
      case "japanese-informal":
        return 26;
      case "kannada":
        return 27;
      case "katakana":
        return 28;
      case "katakana-iroha":
        return 29;
      case "khmer":
        return 30;
      case "korean-hangul-formal":
        return 31;
      case "korean-hanja-formal":
        return 32;
      case "korean-hanja-informal":
        return 33;
      case "lao":
        return 34;
      case "lower-armenian":
        return 35;
      case "malayalam":
        return 36;
      case "mongolian":
        return 37;
      case "myanmar":
        return 38;
      case "oriya":
        return 39;
      case "persian":
        return 40;
      case "simp-chinese-formal":
        return 41;
      case "simp-chinese-informal":
        return 42;
      case "tamil":
        return 43;
      case "telugu":
        return 44;
      case "thai":
        return 45;
      case "tibetan":
        return 46;
      case "trad-chinese-formal":
        return 47;
      case "trad-chinese-informal":
        return 48;
      case "upper-armenian":
        return 49;
      case "disclosure-open":
        return 50;
      case "disclosure-closed":
        return 51;
      case "none":
      default:
        return -1;
    }
  }
}, nr = function(e) {
  return {
    name: "margin-" + e,
    initialValue: "0",
    prefix: !1,
    type: 4
    /* TOKEN_VALUE */
  };
}, po = nr("top"), Eo = nr("right"), Ho = nr("bottom"), mo = nr("left"), vo = {
  name: "overflow",
  initialValue: "visible",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    return A.filter(Z).map(function(r) {
      switch (r.value) {
        case "hidden":
          return 1;
        case "scroll":
          return 2;
        case "clip":
          return 3;
        case "auto":
          return 4;
        case "visible":
        default:
          return 0;
      }
    });
  }
}, Io = {
  name: "overflow-wrap",
  initialValue: "normal",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "break-word":
        return "break-word";
      case "normal":
      default:
        return "normal";
    }
  }
}, sr = function(e) {
  return {
    name: "padding-" + e,
    initialValue: "0",
    prefix: !1,
    type: 3,
    format: "length-percentage"
  };
}, yo = sr("top"), Lo = sr("right"), Ko = sr("bottom"), xo = sr("left"), bo = {
  name: "text-align",
  initialValue: "left",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "right":
        return 2;
      case "center":
      case "justify":
        return 1;
      case "left":
      default:
        return 0;
    }
  }
}, Do = {
  name: "position",
  initialValue: "static",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "relative":
        return 1;
      case "absolute":
        return 2;
      case "fixed":
        return 3;
      case "sticky":
        return 4;
    }
    return 0;
  }
}, To = {
  name: "text-shadow",
  initialValue: "none",
  type: 1,
  prefix: !1,
  parse: function(e, A) {
    return A.length === 1 && $r(A[0], "none") ? [] : NA(A).map(function(r) {
      for (var t = {
        color: YA.TRANSPARENT,
        offsetX: lA,
        offsetY: lA,
        blur: lA
      }, n = 0, s = 0; s < r.length; s++) {
        var B = r[s];
        se(B) ? (n === 0 ? t.offsetX = B : n === 1 ? t.offsetY = B : t.blur = B, n++) : t.color = re.parse(e, B);
      }
      return t;
    });
  }
}, So = {
  name: "text-transform",
  initialValue: "none",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "uppercase":
        return 2;
      case "lowercase":
        return 1;
      case "capitalize":
        return 3;
    }
    return 0;
  }
}, Mo = {
  name: "transform",
  initialValue: "none",
  prefix: !0,
  type: 0,
  parse: function(e, A) {
    if (A.type === 20 && A.value === "none")
      return null;
    if (A.type === 18) {
      var r = Go[A.name];
      if (typeof r > "u")
        throw new Error('Attempting to parse an unsupported transform function "' + A.name + '"');
      return r(A.values);
    }
    return null;
  }
}, Oo = function(e) {
  var A = e.filter(function(r) {
    return r.type === 17;
  }).map(function(r) {
    return r.number;
  });
  return A.length === 6 ? A : null;
}, Ro = function(e) {
  var A = e.filter(function(a) {
    return a.type === 17;
  }).map(function(a) {
    return a.number;
  }), r = A[0], t = A[1];
  A[2], A[3];
  var n = A[4], s = A[5];
  A[6], A[7], A[8], A[9], A[10], A[11];
  var B = A[12], i = A[13];
  return A[14], A[15], A.length === 16 ? [r, t, n, s, B, i] : null;
}, Go = {
  matrix: Oo,
  matrix3d: Ro
}, Zn = {
  type: 16,
  number: 50,
  flags: ze
}, Vo = [Zn, Zn], No = {
  name: "transform-origin",
  initialValue: "50% 50%",
  prefix: !0,
  type: 1,
  parse: function(e, A) {
    var r = A.filter(sA);
    return r.length !== 2 ? Vo : [r[0], r[1]];
  }
}, _o = {
  name: "visible",
  initialValue: "none",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "hidden":
        return 1;
      case "collapse":
        return 2;
      case "visible":
      default:
        return 0;
    }
  }
}, ke;
(function(e) {
  e.NORMAL = "normal", e.BREAK_ALL = "break-all", e.KEEP_ALL = "keep-all";
})(ke || (ke = {}));
var Po = {
  name: "word-break",
  initialValue: "normal",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "break-all":
        return ke.BREAK_ALL;
      case "keep-all":
        return ke.KEEP_ALL;
      case "normal":
      default:
        return ke.NORMAL;
    }
  }
}, Xo = {
  name: "z-index",
  initialValue: "auto",
  prefix: !1,
  type: 0,
  parse: function(e, A) {
    if (A.type === 20)
      return { auto: !0, order: 0 };
    if (Le(A))
      return { auto: !1, order: A.number };
    throw new Error("Invalid z-index number parsed");
  }
}, aB = {
  name: "time",
  parse: function(e, A) {
    if (A.type === 15)
      switch (A.unit.toLowerCase()) {
        case "s":
          return 1e3 * A.number;
        case "ms":
          return A.number;
      }
    throw new Error("Unsupported time type");
  }
}, ko = {
  name: "opacity",
  initialValue: "1",
  type: 0,
  prefix: !1,
  parse: function(e, A) {
    return Le(A) ? A.number : 1;
  }
}, Jo = {
  name: "text-decoration-color",
  initialValue: "transparent",
  prefix: !1,
  type: 3,
  format: "color"
}, Wo = {
  name: "text-decoration-line",
  initialValue: "none",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    return A.filter(Z).map(function(r) {
      switch (r.value) {
        case "underline":
          return 1;
        case "overline":
          return 2;
        case "line-through":
          return 3;
        case "none":
          return 4;
      }
      return 0;
    }).filter(function(r) {
      return r !== 0;
    });
  }
}, Yo = {
  name: "font-family",
  initialValue: "",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    var r = [], t = [];
    return A.forEach(function(n) {
      switch (n.type) {
        case 20:
        case 0:
          r.push(n.value);
          break;
        case 17:
          r.push(n.number.toString());
          break;
        case 4:
          t.push(r.join(" ")), r.length = 0;
          break;
      }
    }), r.length && t.push(r.join(" ")), t.map(function(n) {
      return n.indexOf(" ") === -1 ? n : "'" + n + "'";
    });
  }
}, Zo = {
  name: "font-size",
  initialValue: "0",
  prefix: !1,
  type: 3,
  format: "length"
}, qo = {
  name: "font-weight",
  initialValue: "normal",
  type: 0,
  prefix: !1,
  parse: function(e, A) {
    if (Le(A))
      return A.number;
    if (Z(A))
      switch (A.value) {
        case "bold":
          return 700;
        case "normal":
        default:
          return 400;
      }
    return 400;
  }
}, zo = {
  name: "font-variant",
  initialValue: "none",
  type: 1,
  prefix: !1,
  parse: function(e, A) {
    return A.filter(Z).map(function(r) {
      return r.value;
    });
  }
}, jo = {
  name: "font-style",
  initialValue: "normal",
  prefix: !1,
  type: 2,
  parse: function(e, A) {
    switch (A) {
      case "oblique":
        return "oblique";
      case "italic":
        return "italic";
      case "normal":
      default:
        return "normal";
    }
  }
}, aA = function(e, A) {
  return (e & A) !== 0;
}, $o = {
  name: "content",
  initialValue: "none",
  type: 1,
  prefix: !1,
  parse: function(e, A) {
    if (A.length === 0)
      return [];
    var r = A[0];
    return r.type === 20 && r.value === "none" ? [] : A;
  }
}, Ac = {
  name: "counter-increment",
  initialValue: "none",
  prefix: !0,
  type: 1,
  parse: function(e, A) {
    if (A.length === 0)
      return null;
    var r = A[0];
    if (r.type === 20 && r.value === "none")
      return null;
    for (var t = [], n = A.filter(ks), s = 0; s < n.length; s++) {
      var B = n[s], i = n[s + 1];
      if (B.type === 20) {
        var a = i && Le(i) ? i.number : 1;
        t.push({ counter: B.value, increment: a });
      }
    }
    return t;
  }
}, ec = {
  name: "counter-reset",
  initialValue: "none",
  prefix: !0,
  type: 1,
  parse: function(e, A) {
    if (A.length === 0)
      return [];
    for (var r = [], t = A.filter(ks), n = 0; n < t.length; n++) {
      var s = t[n], B = t[n + 1];
      if (Z(s) && s.value !== "none") {
        var i = B && Le(B) ? B.number : 0;
        r.push({ counter: s.value, reset: i });
      }
    }
    return r;
  }
}, tc = {
  name: "duration",
  initialValue: "0s",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    return A.filter(je).map(function(r) {
      return aB.parse(e, r);
    });
  }
}, rc = {
  name: "quotes",
  initialValue: "none",
  prefix: !0,
  type: 1,
  parse: function(e, A) {
    if (A.length === 0)
      return null;
    var r = A[0];
    if (r.type === 20 && r.value === "none")
      return null;
    var t = [], n = A.filter(ya);
    if (n.length % 2 !== 0)
      return null;
    for (var s = 0; s < n.length; s += 2) {
      var B = n[s].value, i = n[s + 1].value;
      t.push({ open: B, close: i });
    }
    return t;
  }
}, qn = function(e, A, r) {
  if (!e)
    return "";
  var t = e[Math.min(A, e.length - 1)];
  return t ? r ? t.open : t.close : "";
}, nc = {
  name: "box-shadow",
  initialValue: "none",
  type: 1,
  prefix: !1,
  parse: function(e, A) {
    return A.length === 1 && $r(A[0], "none") ? [] : NA(A).map(function(r) {
      for (var t = {
        color: 255,
        offsetX: lA,
        offsetY: lA,
        blur: lA,
        spread: lA,
        inset: !1
      }, n = 0, s = 0; s < r.length; s++) {
        var B = r[s];
        $r(B, "inset") ? t.inset = !0 : se(B) ? (n === 0 ? t.offsetX = B : n === 1 ? t.offsetY = B : n === 2 ? t.blur = B : t.spread = B, n++) : t.color = re.parse(e, B);
      }
      return t;
    });
  }
}, sc = {
  name: "paint-order",
  initialValue: "normal",
  prefix: !1,
  type: 1,
  parse: function(e, A) {
    var r = [
      0,
      1,
      2
      /* MARKERS */
    ], t = [];
    return A.filter(Z).forEach(function(n) {
      switch (n.value) {
        case "stroke":
          t.push(
            1
            /* STROKE */
          );
          break;
        case "fill":
          t.push(
            0
            /* FILL */
          );
          break;
        case "markers":
          t.push(
            2
            /* MARKERS */
          );
          break;
      }
    }), r.forEach(function(n) {
      t.indexOf(n) === -1 && t.push(n);
    }), t;
  }
}, Bc = {
  name: "-webkit-text-stroke-color",
  initialValue: "currentcolor",
  prefix: !1,
  type: 3,
  format: "color"
}, ic = {
  name: "-webkit-text-stroke-width",
  initialValue: "0",
  type: 0,
  prefix: !1,
  parse: function(e, A) {
    return je(A) ? A.number : 0;
  }
}, ac = (
  /** @class */
  (function() {
    function e(A, r) {
      var t, n;
      this.animationDuration = L(A, tc, r.animationDuration), this.backgroundClip = L(A, xa, r.backgroundClip), this.backgroundColor = L(A, ba, r.backgroundColor), this.backgroundImage = L(A, _a, r.backgroundImage), this.backgroundOrigin = L(A, Pa, r.backgroundOrigin), this.backgroundPosition = L(A, Xa, r.backgroundPosition), this.backgroundRepeat = L(A, ka, r.backgroundRepeat), this.backgroundSize = L(A, Wa, r.backgroundSize), this.borderTopColor = L(A, Za, r.borderTopColor), this.borderRightColor = L(A, qa, r.borderRightColor), this.borderBottomColor = L(A, za, r.borderBottomColor), this.borderLeftColor = L(A, ja, r.borderLeftColor), this.borderTopLeftRadius = L(A, $a, r.borderTopLeftRadius), this.borderTopRightRadius = L(A, Ao, r.borderTopRightRadius), this.borderBottomRightRadius = L(A, eo, r.borderBottomRightRadius), this.borderBottomLeftRadius = L(A, to, r.borderBottomLeftRadius), this.borderTopStyle = L(A, ro, r.borderTopStyle), this.borderRightStyle = L(A, no, r.borderRightStyle), this.borderBottomStyle = L(A, so, r.borderBottomStyle), this.borderLeftStyle = L(A, Bo, r.borderLeftStyle), this.borderTopWidth = L(A, io, r.borderTopWidth), this.borderRightWidth = L(A, ao, r.borderRightWidth), this.borderBottomWidth = L(A, oo, r.borderBottomWidth), this.borderLeftWidth = L(A, co, r.borderLeftWidth), this.boxShadow = L(A, nc, r.boxShadow), this.color = L(A, lo, r.color), this.direction = L(A, uo, r.direction), this.display = L(A, go, r.display), this.float = L(A, Qo, r.cssFloat), this.fontFamily = L(A, Yo, r.fontFamily), this.fontSize = L(A, Zo, r.fontSize), this.fontStyle = L(A, jo, r.fontStyle), this.fontVariant = L(A, zo, r.fontVariant), this.fontWeight = L(A, qo, r.fontWeight), this.letterSpacing = L(A, wo, r.letterSpacing), this.lineBreak = L(A, Co, r.lineBreak), this.lineHeight = L(A, ho, r.lineHeight), this.listStyleImage = L(A, Uo, r.listStyleImage), this.listStylePosition = L(A, Fo, r.listStylePosition), this.listStyleType = L(A, An, r.listStyleType), this.marginTop = L(A, po, r.marginTop), this.marginRight = L(A, Eo, r.marginRight), this.marginBottom = L(A, Ho, r.marginBottom), this.marginLeft = L(A, mo, r.marginLeft), this.opacity = L(A, ko, r.opacity);
      var s = L(A, vo, r.overflow);
      this.overflowX = s[0], this.overflowY = s[s.length > 1 ? 1 : 0], this.overflowWrap = L(A, Io, r.overflowWrap), this.paddingTop = L(A, yo, r.paddingTop), this.paddingRight = L(A, Lo, r.paddingRight), this.paddingBottom = L(A, Ko, r.paddingBottom), this.paddingLeft = L(A, xo, r.paddingLeft), this.paintOrder = L(A, sc, r.paintOrder), this.position = L(A, Do, r.position), this.textAlign = L(A, bo, r.textAlign), this.textDecorationColor = L(A, Jo, (t = r.textDecorationColor) !== null && t !== void 0 ? t : r.color), this.textDecorationLine = L(A, Wo, (n = r.textDecorationLine) !== null && n !== void 0 ? n : r.textDecoration), this.textShadow = L(A, To, r.textShadow), this.textTransform = L(A, So, r.textTransform), this.transform = L(A, Mo, r.transform), this.transformOrigin = L(A, No, r.transformOrigin), this.visibility = L(A, _o, r.visibility), this.webkitTextStrokeColor = L(A, Bc, r.webkitTextStrokeColor), this.webkitTextStrokeWidth = L(A, ic, r.webkitTextStrokeWidth), this.wordBreak = L(A, Po, r.wordBreak), this.zIndex = L(A, Xo, r.zIndex);
    }
    return e.prototype.isVisible = function() {
      return this.display > 0 && this.opacity > 0 && this.visibility === 0;
    }, e.prototype.isTransparent = function() {
      return ne(this.backgroundColor);
    }, e.prototype.isTransformed = function() {
      return this.transform !== null;
    }, e.prototype.isPositioned = function() {
      return this.position !== 0;
    }, e.prototype.isPositionedWithZIndex = function() {
      return this.isPositioned() && !this.zIndex.auto;
    }, e.prototype.isFloating = function() {
      return this.float !== 0;
    }, e.prototype.isInlineLevel = function() {
      return aA(
        this.display,
        4
        /* INLINE */
      ) || aA(
        this.display,
        33554432
        /* INLINE_BLOCK */
      ) || aA(
        this.display,
        268435456
        /* INLINE_FLEX */
      ) || aA(
        this.display,
        536870912
        /* INLINE_GRID */
      ) || aA(
        this.display,
        67108864
        /* INLINE_LIST_ITEM */
      ) || aA(
        this.display,
        134217728
        /* INLINE_TABLE */
      );
    }, e;
  })()
), oc = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A, r) {
      this.content = L(A, $o, r.content), this.quotes = L(A, rc, r.quotes);
    }
    return e;
  })()
), zn = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A, r) {
      this.counterIncrement = L(A, Ac, r.counterIncrement), this.counterReset = L(A, ec, r.counterReset);
    }
    return e;
  })()
), L = function(e, A, r) {
  var t = new Ps(), n = r !== null && typeof r < "u" ? r.toString() : A.initialValue;
  t.write(n);
  var s = new Xs(t.read());
  switch (A.type) {
    case 2:
      var B = s.parseComponentValue();
      return A.parse(e, Z(B) ? B.value : A.initialValue);
    case 0:
      return A.parse(e, s.parseComponentValue());
    case 1:
      return A.parse(e, s.parseComponentValues());
    case 4:
      return s.parseComponentValue();
    case 3:
      switch (A.format) {
        case "angle":
          return jt.parse(e, s.parseComponentValue());
        case "color":
          return re.parse(e, s.parseComponentValue());
        case "image":
          return gn.parse(e, s.parseComponentValue());
        case "length":
          var i = s.parseComponentValue();
          return se(i) ? i : lA;
        case "length-percentage":
          var a = s.parseComponentValue();
          return sA(a) ? a : lA;
        case "time":
          return aB.parse(e, s.parseComponentValue());
      }
      break;
  }
}, cc = "data-html2canvas-debug", lc = function(e) {
  var A = e.getAttribute(cc);
  switch (A) {
    case "all":
      return 1;
    case "clone":
      return 2;
    case "parse":
      return 3;
    case "render":
      return 4;
    default:
      return 0;
  }
}, en = function(e, A) {
  var r = lc(e);
  return r === 1 || A === r;
}, _A = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A, r) {
      if (this.context = A, this.textNodes = [], this.elements = [], this.flags = 0, en(
        r,
        3
        /* PARSE */
      ))
        debugger;
      this.styles = new ac(A, window.getComputedStyle(r, null)), nn(r) && (this.styles.animationDuration.some(function(t) {
        return t > 0;
      }) && (r.style.animationDuration = "0s"), this.styles.transform !== null && (r.style.transform = "none")), this.bounds = qt(this.context, r), en(
        r,
        4
        /* RENDER */
      ) && (this.flags |= 16);
    }
    return e;
  })()
), uc = "AAAAAAAAAAAAEA4AGBkAAFAaAAACAAAAAAAIABAAGAAwADgACAAQAAgAEAAIABAACAAQAAgAEAAIABAACAAQAAgAEAAIABAAQABIAEQATAAIABAACAAQAAgAEAAIABAAVABcAAgAEAAIABAACAAQAGAAaABwAHgAgACIAI4AlgAIABAAmwCjAKgAsAC2AL4AvQDFAMoA0gBPAVYBWgEIAAgACACMANoAYgFkAWwBdAF8AX0BhQGNAZUBlgGeAaMBlQGWAasBswF8AbsBwwF0AcsBYwHTAQgA2wG/AOMBdAF8AekB8QF0AfkB+wHiAHQBfAEIAAMC5gQIAAsCEgIIAAgAFgIeAggAIgIpAggAMQI5AkACygEIAAgASAJQAlgCYAIIAAgACAAKBQoFCgUTBRMFGQUrBSsFCAAIAAgACAAIAAgACAAIAAgACABdAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACABoAmgCrwGvAQgAbgJ2AggAHgEIAAgACADnAXsCCAAIAAgAgwIIAAgACAAIAAgACACKAggAkQKZAggAPADJAAgAoQKkAqwCsgK6AsICCADJAggA0AIIAAgACAAIANYC3gIIAAgACAAIAAgACABAAOYCCAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAkASoB+QIEAAgACAA8AEMCCABCBQgACABJBVAFCAAIAAgACAAIAAgACAAIAAgACABTBVoFCAAIAFoFCABfBWUFCAAIAAgACAAIAAgAbQUIAAgACAAIAAgACABzBXsFfQWFBYoFigWKBZEFigWKBYoFmAWfBaYFrgWxBbkFCAAIAAgACAAIAAgACAAIAAgACAAIAMEFCAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAMgFCADQBQgACAAIAAgACAAIAAgACAAIAAgACAAIAO4CCAAIAAgAiQAIAAgACABAAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAD0AggACAD8AggACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIANYFCAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAMDvwAIAAgAJAIIAAgACAAIAAgACAAIAAgACwMTAwgACAB9BOsEGwMjAwgAKwMyAwsFYgE3A/MEPwMIAEUDTQNRAwgAWQOsAGEDCAAIAAgACAAIAAgACABpAzQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFOgU0BTUFNgU3BTgFOQU6BTQFNQU2BTcFOAU5BToFNAU1BTYFNwU4BTkFIQUoBSwFCAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACABtAwgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACABMAEwACAAIAAgACAAIABgACAAIAAgACAC/AAgACAAyAQgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACACAAIAAwAAgACAAIAAgACAAIAAgACAAIAAAARABIAAgACAAIABQASAAIAAgAIABwAEAAjgCIABsAqAC2AL0AigDQAtwC+IJIQqVAZUBWQqVAZUBlQGVAZUBlQGrC5UBlQGVAZUBlQGVAZUBlQGVAXsKlQGVAbAK6wsrDGUMpQzlDJUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAZUBlQGVAfAKAAuZA64AtwCJALoC6ADwAAgAuACgA/oEpgO6AqsD+AAIAAgAswMIAAgACAAIAIkAuwP5AfsBwwPLAwgACAAIAAgACADRA9kDCAAIAOED6QMIAAgACAAIAAgACADuA/YDCAAIAP4DyQAIAAgABgQIAAgAXQAOBAgACAAIAAgACAAIABMECAAIAAgACAAIAAgACAD8AAQBCAAIAAgAGgQiBCoECAExBAgAEAEIAAgACAAIAAgACAAIAAgACAAIAAgACAA4BAgACABABEYECAAIAAgATAQYAQgAVAQIAAgACAAIAAgACAAIAAgACAAIAFoECAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAOQEIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAB+BAcACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAEABhgSMBAgACAAIAAgAlAQIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAwAEAAQABAADAAMAAwADAAQABAAEAAQABAAEAAQABHATAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAdQMIAAgACAAIAAgACAAIAMkACAAIAAgAfQMIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACACFA4kDCAAIAAgACAAIAOcBCAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAIcDCAAIAAgACAAIAAgACAAIAAgACAAIAJEDCAAIAAgACADFAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACABgBAgAZgQIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAbAQCBXIECAAIAHkECAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACABAAJwEQACjBKoEsgQIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAC6BMIECAAIAAgACAAIAAgACABmBAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAxwQIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAGYECAAIAAgAzgQIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgAigWKBYoFigWKBYoFigWKBd0FXwUIAOIF6gXxBYoF3gT5BQAGCAaKBYoFigWKBYoFigWKBYoFigWKBYoFigXWBIoFigWKBYoFigWKBYoFigWKBYsFEAaKBYoFigWKBYoFigWKBRQGCACKBYoFigWKBQgACAAIANEECAAIABgGigUgBggAJgYIAC4GMwaKBYoF0wQ3Bj4GigWKBYoFigWKBYoFigWKBYoFigWKBYoFigUIAAgACAAIAAgACAAIAAgAigWKBYoFigWKBYoFigWKBYoFigWKBYoFigWKBYoFigWKBYoFigWKBYoFigWKBYoFigWKBYoFigWKBYoFigWLBf///////wQABAAEAAQABAAEAAQABAAEAAQAAwAEAAQAAgAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAQADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAAAUAAAAFAAUAAAAFAAUAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAEAAQABAAEAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUABQAFAAUABQAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUAAQAAAAUABQAFAAUABQAFAAAAAAAFAAUAAAAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAUABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAAAFAAUAAQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABwAFAAUABQAFAAAABwAHAAcAAAAHAAcABwAFAAEAAAAAAAAAAAAAAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAcABwAFAAUABQAFAAcABwAFAAUAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAAAAQABAAAAAAAAAAAAAAAFAAUABQAFAAAABwAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAHAAcABwAHAAcAAAAHAAcAAAAAAAUABQAHAAUAAQAHAAEABwAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUABwABAAUABQAFAAUAAAAAAAAAAAAAAAEAAQABAAEAAQABAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABwAFAAUAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUAAQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQABQANAAQABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQABAAEAAQABAAEAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAAEAAQABAAEAAQABAAEAAQABAAEAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAQABAAEAAQABAAEAAQABAAAAAAAAAAAAAAAAAAAAAAABQAHAAUABQAFAAAAAAAAAAcABQAFAAUABQAFAAQABAAEAAQABAAEAAQABAAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAEAAQABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUAAAAFAAUABQAFAAUAAAAFAAUABQAAAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAAAAAAAAAAAAUABQAFAAcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAHAAUAAAAHAAcABwAFAAUABQAFAAUABQAFAAUABwAHAAcABwAFAAcABwAAAAUABQAFAAUABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABwAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAUABwAHAAUABQAFAAUAAAAAAAcABwAAAAAABwAHAAUAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAABQAFAAcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAABwAHAAcABQAFAAAAAAAAAAAABQAFAAAAAAAFAAUABQAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAFAAUABQAFAAUAAAAFAAUABwAAAAcABwAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAFAAUABwAFAAUABQAFAAAAAAAHAAcAAAAAAAcABwAFAAAAAAAAAAAAAAAAAAAABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAcABwAAAAAAAAAHAAcABwAAAAcABwAHAAUAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAABQAHAAcABwAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABwAHAAcABwAAAAUABQAFAAAABQAFAAUABQAAAAAAAAAAAAAAAAAAAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAcABQAHAAcABQAHAAcAAAAFAAcABwAAAAcABwAFAAUAAAAAAAAAAAAAAAAAAAAFAAUAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAcABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAAAAUABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAAAAAAAAAFAAcABwAFAAUABQAAAAUAAAAHAAcABwAHAAcABwAHAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAHAAUABQAFAAUABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAABwAFAAUABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAUAAAAFAAAAAAAAAAAABwAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABwAFAAUABQAFAAUAAAAFAAUAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUABQAFAAUABQAAAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABwAFAAUABQAFAAUABQAAAAUABQAHAAcABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAcABQAFAAAAAAAAAAAABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAcABQAFAAAAAAAAAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAHAAUABQAFAAUABQAFAAUABwAHAAcABwAHAAcABwAHAAUABwAHAAUABQAFAAUABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABwAHAAcABwAFAAUABwAHAAcAAAAAAAAAAAAHAAcABQAHAAcABwAHAAcABwAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAcABwAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABQAHAAUABQAFAAUABQAFAAUAAAAFAAAABQAAAAAABQAFAAUABQAFAAUABQAFAAcABwAHAAcABwAHAAUABQAFAAUABQAFAAUABQAFAAUAAAAAAAUABQAFAAUABQAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUABwAFAAcABwAHAAcABwAFAAcABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAUABQAFAAUABwAHAAUABQAHAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAcABQAFAAcABwAHAAUABwAFAAUABQAHAAcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAHAAcABwAHAAcABwAHAAUABQAFAAUABQAFAAUABQAHAAcABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUAAAAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAcABQAFAAUABQAFAAUABQAAAAAAAAAAAAUAAAAAAAAAAAAAAAAABQAAAAAABwAFAAUAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAAABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUAAAAFAAUABQAFAAUABQAFAAUABQAFAAAAAAAAAAAABQAAAAAAAAAFAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAHAAUABQAHAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABwAHAAcABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAUABQAFAAUABQAHAAcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAcABwAFAAUABQAFAAcABwAFAAUABwAHAAAAAAAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAFAAcABwAFAAUABwAHAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAFAAcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAFAAUABQAAAAAABQAFAAAAAAAAAAAAAAAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABQAFAAcABwAAAAAAAAAAAAAABwAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABwAFAAcABwAFAAcABwAAAAcABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAAAAAAAAAAAAAAAAAFAAUABQAAAAUABQAAAAAAAAAAAAAABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAAAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABQAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABwAFAAUABQAFAAUABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAHAAcABQAFAAUABQAFAAUABQAFAAUABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAcABwAFAAUABQAHAAcABQAHAAUABQAAAAAAAAAAAAAAAAAFAAAABwAHAAcABQAFAAUABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABwAHAAcABwAAAAAABwAHAAAAAAAHAAcABwAAAAAAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAHAAAAAAAFAAUABQAFAAUABQAFAAAAAAAAAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAcABwAFAAUABQAFAAUABQAFAAUABwAHAAUABQAFAAcABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAHAAcABQAFAAUABQAFAAUABwAFAAcABwAFAAcABQAFAAcABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAHAAcABQAFAAUABQAAAAAABwAHAAcABwAFAAUABwAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABwAHAAUABQAFAAUABQAFAAUABQAHAAcABQAHAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABwAFAAcABwAFAAUABQAFAAUABQAHAAUAAAAAAAAAAAAAAAAAAAAAAAcABwAFAAUABQAFAAcABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAcABwAFAAUABQAFAAUABQAFAAUABQAHAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAcABwAFAAUABQAFAAAAAAAFAAUABwAHAAcABwAFAAAAAAAAAAcAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUABwAHAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABQAFAAUABQAFAAUABQAAAAUABQAFAAUABQAFAAcABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUAAAAHAAUABQAFAAUABQAFAAUABwAFAAUABwAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUAAAAAAAAABQAAAAUABQAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAcABwAHAAcAAAAFAAUAAAAHAAcABQAHAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABwAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAAAAAAAAAAAAAAAAAAABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAAAAUABQAFAAAAAAAFAAUABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAAAAAAAAAAABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAFAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAUABQAFAAUABQAAAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUABQAAAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAFAAUABQAAAAAABQAFAAUABQAFAAUABQAAAAUABQAAAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAAUABQAFAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABQAFAAUABQAFAAUABQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAFAAUABQAFAAUADgAOAA4ADgAOAA4ADwAPAA8ADwAPAA8ADwAPAA8ADwAPAA8ADwAPAA8ADwAPAA8ADwAPAA8ADwAPAA8ADwAPAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAcABwAHAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAgACAAIAAAAAAAAAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAMAAwADAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkACQAJAAkAAAAAAAAAAAAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAKAAoACgAAAAAAAAAAAAsADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwACwAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAMAAwADAAAAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAA4ADgAOAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4ADgAAAAAAAAAAAAAAAAAAAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAA4ADgAOAA4ADgAOAA4ADgAOAAAAAAAAAAAADgAOAA4AAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAA4ADgAAAA4ADgAOAA4ADgAOAAAADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4AAAAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4AAAAAAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAAAA4AAAAOAAAAAAAAAAAAAAAAAA4AAAAAAAAAAAAAAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAAAAAADgAAAAAAAAAAAA4AAAAOAAAAAAAAAAAADgAOAA4AAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAA4ADgAOAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4ADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAAAAAAAAAAAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4ADgAOAA4ADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAAAAAADgAOAA4ADgAOAA4ADgAOAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAAAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4AAAAAAA4ADgAOAA4ADgAOAA4ADgAOAAAADgAOAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4AAAAAAAAAAAAAAAAADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAA4ADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAA4ADgAOAA4ADgAOAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAOAA4ADgAOAA4AAAAAAAAAAAAAAAAAAAAAAA4ADgAOAA4ADgAOAA4ADgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4AAAAOAA4ADgAOAA4ADgAAAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4ADgAOAA4AAAAAAAAAAAA=", jn = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", Ne = typeof Uint8Array > "u" ? [] : new Uint8Array(256);
for (var yt = 0; yt < jn.length; yt++)
  Ne[jn.charCodeAt(yt)] = yt;
var gc = function(e) {
  var A = e.length * 0.75, r = e.length, t, n = 0, s, B, i, a;
  e[e.length - 1] === "=" && (A--, e[e.length - 2] === "=" && A--);
  var c = typeof ArrayBuffer < "u" && typeof Uint8Array < "u" && typeof Uint8Array.prototype.slice < "u" ? new ArrayBuffer(A) : new Array(A), o = Array.isArray(c) ? c : new Uint8Array(c);
  for (t = 0; t < r; t += 4)
    s = Ne[e.charCodeAt(t)], B = Ne[e.charCodeAt(t + 1)], i = Ne[e.charCodeAt(t + 2)], a = Ne[e.charCodeAt(t + 3)], o[n++] = s << 2 | B >> 4, o[n++] = (B & 15) << 4 | i >> 2, o[n++] = (i & 3) << 6 | a & 63;
  return c;
}, fc = function(e) {
  for (var A = e.length, r = [], t = 0; t < A; t += 2)
    r.push(e[t + 1] << 8 | e[t]);
  return r;
}, Qc = function(e) {
  for (var A = e.length, r = [], t = 0; t < A; t += 4)
    r.push(e[t + 3] << 24 | e[t + 2] << 16 | e[t + 1] << 8 | e[t]);
  return r;
}, ue = 5, fn = 11, Hr = 2, wc = fn - ue, oB = 65536 >> ue, Cc = 1 << ue, mr = Cc - 1, hc = 1024 >> ue, Uc = oB + hc, Fc = Uc, dc = 32, pc = Fc + dc, Ec = 65536 >> fn, Hc = 1 << wc, mc = Hc - 1, $n = function(e, A, r) {
  return e.slice ? e.slice(A, r) : new Uint16Array(Array.prototype.slice.call(e, A, r));
}, vc = function(e, A, r) {
  return e.slice ? e.slice(A, r) : new Uint32Array(Array.prototype.slice.call(e, A, r));
}, Ic = function(e, A) {
  var r = gc(e), t = Array.isArray(r) ? Qc(r) : new Uint32Array(r), n = Array.isArray(r) ? fc(r) : new Uint16Array(r), s = 24, B = $n(n, s / 2, t[4] / 2), i = t[5] === 2 ? $n(n, (s + t[4]) / 2) : vc(t, Math.ceil((s + t[4]) / 4));
  return new yc(t[0], t[1], t[2], t[3], B, i);
}, yc = (
  /** @class */
  (function() {
    function e(A, r, t, n, s, B) {
      this.initialValue = A, this.errorValue = r, this.highStart = t, this.highValueIndex = n, this.index = s, this.data = B;
    }
    return e.prototype.get = function(A) {
      var r;
      if (A >= 0) {
        if (A < 55296 || A > 56319 && A <= 65535)
          return r = this.index[A >> ue], r = (r << Hr) + (A & mr), this.data[r];
        if (A <= 65535)
          return r = this.index[oB + (A - 55296 >> ue)], r = (r << Hr) + (A & mr), this.data[r];
        if (A < this.highStart)
          return r = pc - Ec + (A >> fn), r = this.index[r], r += A >> ue & mc, r = this.index[r], r = (r << Hr) + (A & mr), this.data[r];
        if (A <= 1114111)
          return this.data[this.highValueIndex];
      }
      return this.errorValue;
    }, e;
  })()
), As = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", Lc = typeof Uint8Array > "u" ? [] : new Uint8Array(256);
for (var Lt = 0; Lt < As.length; Lt++)
  Lc[As.charCodeAt(Lt)] = Lt;
var Kc = 1, vr = 2, Ir = 3, es = 4, ts = 5, xc = 7, rs = 8, yr = 9, Lr = 10, ns = 11, ss = 12, Bs = 13, is = 14, Kr = 15, bc = function(e) {
  for (var A = [], r = 0, t = e.length; r < t; ) {
    var n = e.charCodeAt(r++);
    if (n >= 55296 && n <= 56319 && r < t) {
      var s = e.charCodeAt(r++);
      (s & 64512) === 56320 ? A.push(((n & 1023) << 10) + (s & 1023) + 65536) : (A.push(n), r--);
    } else
      A.push(n);
  }
  return A;
}, Dc = function() {
  for (var e = [], A = 0; A < arguments.length; A++)
    e[A] = arguments[A];
  if (String.fromCodePoint)
    return String.fromCodePoint.apply(String, e);
  var r = e.length;
  if (!r)
    return "";
  for (var t = [], n = -1, s = ""; ++n < r; ) {
    var B = e[n];
    B <= 65535 ? t.push(B) : (B -= 65536, t.push((B >> 10) + 55296, B % 1024 + 56320)), (n + 1 === r || t.length > 16384) && (s += String.fromCharCode.apply(String, t), t.length = 0);
  }
  return s;
}, Tc = Ic(uc), IA = "×", xr = "÷", Sc = function(e) {
  return Tc.get(e);
}, Mc = function(e, A, r) {
  var t = r - 2, n = A[t], s = A[r - 1], B = A[r];
  if (s === vr && B === Ir)
    return IA;
  if (s === vr || s === Ir || s === es || B === vr || B === Ir || B === es)
    return xr;
  if (s === rs && [rs, yr, ns, ss].indexOf(B) !== -1 || (s === ns || s === yr) && (B === yr || B === Lr) || (s === ss || s === Lr) && B === Lr || B === Bs || B === ts || B === xc || s === Kc)
    return IA;
  if (s === Bs && B === is) {
    for (; n === ts; )
      n = A[--t];
    if (n === is)
      return IA;
  }
  if (s === Kr && B === Kr) {
    for (var i = 0; n === Kr; )
      i++, n = A[--t];
    if (i % 2 === 0)
      return IA;
  }
  return xr;
}, Oc = function(e) {
  var A = bc(e), r = A.length, t = 0, n = 0, s = A.map(Sc);
  return {
    next: function() {
      if (t >= r)
        return { done: !0, value: null };
      for (var B = IA; t < r && (B = Mc(A, s, ++t)) === IA; )
        ;
      if (B !== IA || t === r) {
        var i = Dc.apply(null, A.slice(n, t));
        return n = t, { value: i, done: !1 };
      }
      return { done: !0, value: null };
    }
  };
}, Rc = function(e) {
  for (var A = Oc(e), r = [], t; !(t = A.next()).done; )
    t.value && r.push(t.value.slice());
  return r;
}, Gc = function(e) {
  var A = 123;
  if (e.createRange) {
    var r = e.createRange();
    if (r.getBoundingClientRect) {
      var t = e.createElement("boundtest");
      t.style.height = A + "px", t.style.display = "block", e.body.appendChild(t), r.selectNode(t);
      var n = r.getBoundingClientRect(), s = Math.round(n.height);
      if (e.body.removeChild(t), s === A)
        return !0;
    }
  }
  return !1;
}, Vc = function(e) {
  var A = e.createElement("boundtest");
  A.style.width = "50px", A.style.display = "block", A.style.fontSize = "12px", A.style.letterSpacing = "0px", A.style.wordSpacing = "0px", e.body.appendChild(A);
  var r = e.createRange();
  A.innerHTML = typeof "".repeat == "function" ? "&#128104;".repeat(10) : "";
  var t = A.firstChild, n = zt(t.data).map(function(a) {
    return nA(a);
  }), s = 0, B = {}, i = n.every(function(a, c) {
    r.setStart(t, s), r.setEnd(t, s + a.length);
    var o = r.getBoundingClientRect();
    s += a.length;
    var g = o.x > B.x || o.y > B.y;
    return B = o, c === 0 ? !0 : g;
  });
  return e.body.removeChild(A), i;
}, Nc = function() {
  return typeof new Image().crossOrigin < "u";
}, _c = function() {
  return typeof new XMLHttpRequest().responseType == "string";
}, Pc = function(e) {
  var A = new Image(), r = e.createElement("canvas"), t = r.getContext("2d");
  if (!t)
    return !1;
  A.src = "data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg'></svg>";
  try {
    t.drawImage(A, 0, 0), r.toDataURL();
  } catch {
    return !1;
  }
  return !0;
}, as = function(e) {
  return e[0] === 0 && e[1] === 255 && e[2] === 0 && e[3] === 255;
}, Xc = function(e) {
  var A = e.createElement("canvas"), r = 100;
  A.width = r, A.height = r;
  var t = A.getContext("2d");
  if (!t)
    return Promise.reject(!1);
  t.fillStyle = "rgb(0, 255, 0)", t.fillRect(0, 0, r, r);
  var n = new Image(), s = A.toDataURL();
  n.src = s;
  var B = tn(r, r, 0, 0, n);
  return t.fillStyle = "red", t.fillRect(0, 0, r, r), os(B).then(function(i) {
    t.drawImage(i, 0, 0);
    var a = t.getImageData(0, 0, r, r).data;
    t.fillStyle = "red", t.fillRect(0, 0, r, r);
    var c = e.createElement("div");
    return c.style.backgroundImage = "url(" + s + ")", c.style.height = r + "px", as(a) ? os(tn(r, r, 0, 0, c)) : Promise.reject(!1);
  }).then(function(i) {
    return t.drawImage(i, 0, 0), as(t.getImageData(0, 0, r, r).data);
  }).catch(function() {
    return !1;
  });
}, tn = function(e, A, r, t, n) {
  var s = "http://www.w3.org/2000/svg", B = document.createElementNS(s, "svg"), i = document.createElementNS(s, "foreignObject");
  return B.setAttributeNS(null, "width", e.toString()), B.setAttributeNS(null, "height", A.toString()), i.setAttributeNS(null, "width", "100%"), i.setAttributeNS(null, "height", "100%"), i.setAttributeNS(null, "x", r.toString()), i.setAttributeNS(null, "y", t.toString()), i.setAttributeNS(null, "externalResourcesRequired", "true"), B.appendChild(i), i.appendChild(n), B;
}, os = function(e) {
  return new Promise(function(A, r) {
    var t = new Image();
    t.onload = function() {
      return A(t);
    }, t.onerror = r, t.src = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(new XMLSerializer().serializeToString(e));
  });
}, cA = {
  get SUPPORT_RANGE_BOUNDS() {
    var e = Gc(document);
    return Object.defineProperty(cA, "SUPPORT_RANGE_BOUNDS", { value: e }), e;
  },
  get SUPPORT_WORD_BREAKING() {
    var e = cA.SUPPORT_RANGE_BOUNDS && Vc(document);
    return Object.defineProperty(cA, "SUPPORT_WORD_BREAKING", { value: e }), e;
  },
  get SUPPORT_SVG_DRAWING() {
    var e = Pc(document);
    return Object.defineProperty(cA, "SUPPORT_SVG_DRAWING", { value: e }), e;
  },
  get SUPPORT_FOREIGNOBJECT_DRAWING() {
    var e = typeof Array.from == "function" && typeof window.fetch == "function" ? Xc(document) : Promise.resolve(!1);
    return Object.defineProperty(cA, "SUPPORT_FOREIGNOBJECT_DRAWING", { value: e }), e;
  },
  get SUPPORT_CORS_IMAGES() {
    var e = Nc();
    return Object.defineProperty(cA, "SUPPORT_CORS_IMAGES", { value: e }), e;
  },
  get SUPPORT_RESPONSE_TYPE() {
    var e = _c();
    return Object.defineProperty(cA, "SUPPORT_RESPONSE_TYPE", { value: e }), e;
  },
  get SUPPORT_CORS_XHR() {
    var e = "withCredentials" in new XMLHttpRequest();
    return Object.defineProperty(cA, "SUPPORT_CORS_XHR", { value: e }), e;
  },
  get SUPPORT_NATIVE_TEXT_SEGMENTATION() {
    var e = !!(typeof Intl < "u" && Intl.Segmenter);
    return Object.defineProperty(cA, "SUPPORT_NATIVE_TEXT_SEGMENTATION", { value: e }), e;
  }
}, Je = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A, r) {
      this.text = A, this.bounds = r;
    }
    return e;
  })()
), kc = function(e, A, r, t) {
  var n = Yc(A, r), s = [], B = 0;
  return n.forEach(function(i) {
    if (r.textDecorationLine.length || i.trim().length > 0)
      if (cA.SUPPORT_RANGE_BOUNDS) {
        var a = cs(t, B, i.length).getClientRects();
        if (a.length > 1) {
          var c = Qn(i), o = 0;
          c.forEach(function(f) {
            s.push(new Je(f, ZA.fromDOMRectList(e, cs(t, o + B, f.length).getClientRects()))), o += f.length;
          });
        } else
          s.push(new Je(i, ZA.fromDOMRectList(e, a)));
      } else {
        var g = t.splitText(i.length);
        s.push(new Je(i, Jc(e, t))), t = g;
      }
    else cA.SUPPORT_RANGE_BOUNDS || (t = t.splitText(i.length));
    B += i.length;
  }), s;
}, Jc = function(e, A) {
  var r = A.ownerDocument;
  if (r) {
    var t = r.createElement("html2canvaswrapper");
    t.appendChild(A.cloneNode(!0));
    var n = A.parentNode;
    if (n) {
      n.replaceChild(t, A);
      var s = qt(e, t);
      return t.firstChild && n.replaceChild(t.firstChild, t), s;
    }
  }
  return ZA.EMPTY;
}, cs = function(e, A, r) {
  var t = e.ownerDocument;
  if (!t)
    throw new Error("Node has no owner document");
  var n = t.createRange();
  return n.setStart(e, A), n.setEnd(e, A + r), n;
}, Qn = function(e) {
  if (cA.SUPPORT_NATIVE_TEXT_SEGMENTATION) {
    var A = new Intl.Segmenter(void 0, { granularity: "grapheme" });
    return Array.from(A.segment(e)).map(function(r) {
      return r.segment;
    });
  }
  return Rc(e);
}, Wc = function(e, A) {
  if (cA.SUPPORT_NATIVE_TEXT_SEGMENTATION) {
    var r = new Intl.Segmenter(void 0, {
      granularity: "word"
    });
    return Array.from(r.segment(e)).map(function(t) {
      return t.segment;
    });
  }
  return qc(e, A);
}, Yc = function(e, A) {
  return A.letterSpacing !== 0 ? Qn(e) : Wc(e, A);
}, Zc = [32, 160, 4961, 65792, 65793, 4153, 4241], qc = function(e, A) {
  for (var r = pi(e, {
    lineBreak: A.lineBreak,
    wordBreak: A.overflowWrap === "break-word" ? "break-word" : A.wordBreak
  }), t = [], n, s = function() {
    if (n.value) {
      var B = n.value.slice(), i = zt(B), a = "";
      i.forEach(function(c) {
        Zc.indexOf(c) === -1 ? a += nA(c) : (a.length && t.push(a), t.push(nA(c)), a = "");
      }), a.length && t.push(a);
    }
  }; !(n = r.next()).done; )
    s();
  return t;
}, zc = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A, r, t) {
      this.text = jc(r.data, t.textTransform), this.textBounds = kc(A, this.text, t, r);
    }
    return e;
  })()
), jc = function(e, A) {
  switch (A) {
    case 1:
      return e.toLowerCase();
    case 3:
      return e.replace($c, Al);
    case 2:
      return e.toUpperCase();
    default:
      return e;
  }
}, $c = /(^|\s|:|-|\(|\))([a-z])/g, Al = function(e, A, r) {
  return e.length > 0 ? A + r.toUpperCase() : e;
}, cB = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      return n.src = t.currentSrc || t.src, n.intrinsicWidth = t.naturalWidth, n.intrinsicHeight = t.naturalHeight, n.context.cache.addImage(n.src), n;
    }
    return A;
  })(_A)
), lB = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      return n.canvas = t, n.intrinsicWidth = t.width, n.intrinsicHeight = t.height, n;
    }
    return A;
  })(_A)
), uB = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this, s = new XMLSerializer(), B = qt(r, t);
      return t.setAttribute("width", B.width + "px"), t.setAttribute("height", B.height + "px"), n.svg = "data:image/svg+xml," + encodeURIComponent(s.serializeToString(t)), n.intrinsicWidth = t.width.baseVal.value, n.intrinsicHeight = t.height.baseVal.value, n.context.cache.addImage(n.svg), n;
    }
    return A;
  })(_A)
), gB = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      return n.value = t.value, n;
    }
    return A;
  })(_A)
), rn = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      return n.start = t.start, n.reversed = typeof t.reversed == "boolean" && t.reversed === !0, n;
    }
    return A;
  })(_A)
), el = [
  {
    type: 15,
    flags: 0,
    unit: "px",
    number: 3
  }
], tl = [
  {
    type: 16,
    flags: 0,
    number: 50
  }
], rl = function(e) {
  return e.width > e.height ? new ZA(e.left + (e.width - e.height) / 2, e.top, e.height, e.height) : e.width < e.height ? new ZA(e.left, e.top + (e.height - e.width) / 2, e.width, e.width) : e;
}, nl = function(e) {
  var A = e.type === sl ? new Array(e.value.length + 1).join("•") : e.value;
  return A.length === 0 ? e.placeholder || "" : A;
}, Pt = "checkbox", Xt = "radio", sl = "password", ls = 707406591, wn = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      switch (n.type = t.type.toLowerCase(), n.checked = t.checked, n.value = nl(t), (n.type === Pt || n.type === Xt) && (n.styles.backgroundColor = 3739148031, n.styles.borderTopColor = n.styles.borderRightColor = n.styles.borderBottomColor = n.styles.borderLeftColor = 2779096575, n.styles.borderTopWidth = n.styles.borderRightWidth = n.styles.borderBottomWidth = n.styles.borderLeftWidth = 1, n.styles.borderTopStyle = n.styles.borderRightStyle = n.styles.borderBottomStyle = n.styles.borderLeftStyle = 1, n.styles.backgroundClip = [
        0
        /* BORDER_BOX */
      ], n.styles.backgroundOrigin = [
        0
        /* BORDER_BOX */
      ], n.bounds = rl(n.bounds)), n.type) {
        case Pt:
          n.styles.borderTopRightRadius = n.styles.borderTopLeftRadius = n.styles.borderBottomRightRadius = n.styles.borderBottomLeftRadius = el;
          break;
        case Xt:
          n.styles.borderTopRightRadius = n.styles.borderTopLeftRadius = n.styles.borderBottomRightRadius = n.styles.borderBottomLeftRadius = tl;
          break;
      }
      return n;
    }
    return A;
  })(_A)
), fB = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this, s = t.options[t.selectedIndex || 0];
      return n.value = s && s.text || "", n;
    }
    return A;
  })(_A)
), QB = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      return n.value = t.value, n;
    }
    return A;
  })(_A)
), wB = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      n.src = t.src, n.width = parseInt(t.width, 10) || 0, n.height = parseInt(t.height, 10) || 0, n.backgroundColor = n.styles.backgroundColor;
      try {
        if (t.contentWindow && t.contentWindow.document && t.contentWindow.document.documentElement) {
          n.tree = hB(r, t.contentWindow.document.documentElement);
          var s = t.contentWindow.document.documentElement ? Xe(r, getComputedStyle(t.contentWindow.document.documentElement).backgroundColor) : YA.TRANSPARENT, B = t.contentWindow.document.body ? Xe(r, getComputedStyle(t.contentWindow.document.body).backgroundColor) : YA.TRANSPARENT;
          n.backgroundColor = ne(s) ? ne(B) ? n.styles.backgroundColor : B : s;
        }
      } catch {
      }
      return n;
    }
    return A;
  })(_A)
), Bl = ["OL", "UL", "MENU"], Rt = function(e, A, r, t) {
  for (var n = A.firstChild, s = void 0; n; n = s)
    if (s = n.nextSibling, UB(n) && n.data.trim().length > 0)
      r.textNodes.push(new zc(e, n, r.styles));
    else if (ve(n))
      if (EB(n) && n.assignedNodes)
        n.assignedNodes().forEach(function(i) {
          return Rt(e, i, r, t);
        });
      else {
        var B = CB(e, n);
        B.styles.isVisible() && (il(n, B, t) ? B.flags |= 4 : al(B.styles) && (B.flags |= 2), Bl.indexOf(n.tagName) !== -1 && (B.flags |= 8), r.elements.push(B), n.slot, n.shadowRoot ? Rt(e, n.shadowRoot, B, t) : !kt(n) && !FB(n) && !Jt(n) && Rt(e, n, B, t));
      }
}, CB = function(e, A) {
  return sn(A) ? new cB(e, A) : dB(A) ? new lB(e, A) : FB(A) ? new uB(e, A) : ol(A) ? new gB(e, A) : cl(A) ? new rn(e, A) : ll(A) ? new wn(e, A) : Jt(A) ? new fB(e, A) : kt(A) ? new QB(e, A) : pB(A) ? new wB(e, A) : new _A(e, A);
}, hB = function(e, A) {
  var r = CB(e, A);
  return r.flags |= 4, Rt(e, A, r, r), r;
}, il = function(e, A, r) {
  return A.styles.isPositionedWithZIndex() || A.styles.opacity < 1 || A.styles.isTransformed() || Cn(e) && r.styles.isTransparent();
}, al = function(e) {
  return e.isPositioned() || e.isFloating();
}, UB = function(e) {
  return e.nodeType === Node.TEXT_NODE;
}, ve = function(e) {
  return e.nodeType === Node.ELEMENT_NODE;
}, nn = function(e) {
  return ve(e) && typeof e.style < "u" && !Gt(e);
}, Gt = function(e) {
  return typeof e.className == "object";
}, ol = function(e) {
  return e.tagName === "LI";
}, cl = function(e) {
  return e.tagName === "OL";
}, ll = function(e) {
  return e.tagName === "INPUT";
}, ul = function(e) {
  return e.tagName === "HTML";
}, FB = function(e) {
  return e.tagName === "svg";
}, Cn = function(e) {
  return e.tagName === "BODY";
}, dB = function(e) {
  return e.tagName === "CANVAS";
}, us = function(e) {
  return e.tagName === "VIDEO";
}, sn = function(e) {
  return e.tagName === "IMG";
}, pB = function(e) {
  return e.tagName === "IFRAME";
}, gs = function(e) {
  return e.tagName === "STYLE";
}, gl = function(e) {
  return e.tagName === "SCRIPT";
}, kt = function(e) {
  return e.tagName === "TEXTAREA";
}, Jt = function(e) {
  return e.tagName === "SELECT";
}, EB = function(e) {
  return e.tagName === "SLOT";
}, fs = function(e) {
  return e.tagName.indexOf("-") > 0;
}, fl = (
  /** @class */
  (function() {
    function e() {
      this.counters = {};
    }
    return e.prototype.getCounterValue = function(A) {
      var r = this.counters[A];
      return r && r.length ? r[r.length - 1] : 1;
    }, e.prototype.getCounterValues = function(A) {
      var r = this.counters[A];
      return r || [];
    }, e.prototype.pop = function(A) {
      var r = this;
      A.forEach(function(t) {
        return r.counters[t].pop();
      });
    }, e.prototype.parse = function(A) {
      var r = this, t = A.counterIncrement, n = A.counterReset, s = !0;
      t !== null && t.forEach(function(i) {
        var a = r.counters[i.counter];
        a && i.increment !== 0 && (s = !1, a.length || a.push(1), a[Math.max(0, a.length - 1)] += i.increment);
      });
      var B = [];
      return s && n.forEach(function(i) {
        var a = r.counters[i.counter];
        B.push(i.counter), a || (a = r.counters[i.counter] = []), a.push(i.reset);
      }), B;
    }, e;
  })()
), Qs = {
  integers: [1e3, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1],
  values: ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
}, ws = {
  integers: [
    9e3,
    8e3,
    7e3,
    6e3,
    5e3,
    4e3,
    3e3,
    2e3,
    1e3,
    900,
    800,
    700,
    600,
    500,
    400,
    300,
    200,
    100,
    90,
    80,
    70,
    60,
    50,
    40,
    30,
    20,
    10,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
    1
  ],
  values: [
    "Ք",
    "Փ",
    "Ւ",
    "Ց",
    "Ր",
    "Տ",
    "Վ",
    "Ս",
    "Ռ",
    "Ջ",
    "Պ",
    "Չ",
    "Ո",
    "Շ",
    "Ն",
    "Յ",
    "Մ",
    "Ճ",
    "Ղ",
    "Ձ",
    "Հ",
    "Կ",
    "Ծ",
    "Խ",
    "Լ",
    "Ի",
    "Ժ",
    "Թ",
    "Ը",
    "Է",
    "Զ",
    "Ե",
    "Դ",
    "Գ",
    "Բ",
    "Ա"
  ]
}, Ql = {
  integers: [
    1e4,
    9e3,
    8e3,
    7e3,
    6e3,
    5e3,
    4e3,
    3e3,
    2e3,
    1e3,
    400,
    300,
    200,
    100,
    90,
    80,
    70,
    60,
    50,
    40,
    30,
    20,
    19,
    18,
    17,
    16,
    15,
    10,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
    1
  ],
  values: [
    "י׳",
    "ט׳",
    "ח׳",
    "ז׳",
    "ו׳",
    "ה׳",
    "ד׳",
    "ג׳",
    "ב׳",
    "א׳",
    "ת",
    "ש",
    "ר",
    "ק",
    "צ",
    "פ",
    "ע",
    "ס",
    "נ",
    "מ",
    "ל",
    "כ",
    "יט",
    "יח",
    "יז",
    "טז",
    "טו",
    "י",
    "ט",
    "ח",
    "ז",
    "ו",
    "ה",
    "ד",
    "ג",
    "ב",
    "א"
  ]
}, wl = {
  integers: [
    1e4,
    9e3,
    8e3,
    7e3,
    6e3,
    5e3,
    4e3,
    3e3,
    2e3,
    1e3,
    900,
    800,
    700,
    600,
    500,
    400,
    300,
    200,
    100,
    90,
    80,
    70,
    60,
    50,
    40,
    30,
    20,
    10,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
    1
  ],
  values: [
    "ჵ",
    "ჰ",
    "ჯ",
    "ჴ",
    "ხ",
    "ჭ",
    "წ",
    "ძ",
    "ც",
    "ჩ",
    "შ",
    "ყ",
    "ღ",
    "ქ",
    "ფ",
    "ჳ",
    "ტ",
    "ს",
    "რ",
    "ჟ",
    "პ",
    "ო",
    "ჲ",
    "ნ",
    "მ",
    "ლ",
    "კ",
    "ი",
    "თ",
    "ჱ",
    "ზ",
    "ვ",
    "ე",
    "დ",
    "გ",
    "ბ",
    "ა"
  ]
}, de = function(e, A, r, t, n, s) {
  return e < A || e > r ? qe(e, n, s.length > 0) : t.integers.reduce(function(B, i, a) {
    for (; e >= i; )
      e -= i, B += t.values[a];
    return B;
  }, "") + s;
}, HB = function(e, A, r, t) {
  var n = "";
  do
    r || e--, n = t(e) + n, e /= A;
  while (e * A >= A);
  return n;
}, rA = function(e, A, r, t, n) {
  var s = r - A + 1;
  return (e < 0 ? "-" : "") + (HB(Math.abs(e), s, t, function(B) {
    return nA(Math.floor(B % s) + A);
  }) + n);
}, ae = function(e, A, r) {
  r === void 0 && (r = ". ");
  var t = A.length;
  return HB(Math.abs(e), t, !1, function(n) {
    return A[Math.floor(n % t)];
  }) + r;
}, He = 1, zA = 2, jA = 4, _e = 8, WA = function(e, A, r, t, n, s) {
  if (e < -9999 || e > 9999)
    return qe(e, 4, n.length > 0);
  var B = Math.abs(e), i = n;
  if (B === 0)
    return A[0] + i;
  for (var a = 0; B > 0 && a <= 4; a++) {
    var c = B % 10;
    c === 0 && aA(s, He) && i !== "" ? i = A[c] + i : c > 1 || c === 1 && a === 0 || c === 1 && a === 1 && aA(s, zA) || c === 1 && a === 1 && aA(s, jA) && e > 100 || c === 1 && a > 1 && aA(s, _e) ? i = A[c] + (a > 0 ? r[a - 1] : "") + i : c === 1 && a > 0 && (i = r[a - 1] + i), B = Math.floor(B / 10);
  }
  return (e < 0 ? t : "") + i;
}, Cs = "十百千萬", hs = "拾佰仟萬", Us = "マイナス", br = "마이너스", qe = function(e, A, r) {
  var t = r ? ". " : "", n = r ? "、" : "", s = r ? ", " : "", B = r ? " " : "";
  switch (A) {
    case 0:
      return "•" + B;
    case 1:
      return "◦" + B;
    case 2:
      return "◾" + B;
    case 5:
      var i = rA(e, 48, 57, !0, t);
      return i.length < 4 ? "0" + i : i;
    case 4:
      return ae(e, "〇一二三四五六七八九", n);
    case 6:
      return de(e, 1, 3999, Qs, 3, t).toLowerCase();
    case 7:
      return de(e, 1, 3999, Qs, 3, t);
    case 8:
      return rA(e, 945, 969, !1, t);
    case 9:
      return rA(e, 97, 122, !1, t);
    case 10:
      return rA(e, 65, 90, !1, t);
    case 11:
      return rA(e, 1632, 1641, !0, t);
    case 12:
    case 49:
      return de(e, 1, 9999, ws, 3, t);
    case 35:
      return de(e, 1, 9999, ws, 3, t).toLowerCase();
    case 13:
      return rA(e, 2534, 2543, !0, t);
    case 14:
    case 30:
      return rA(e, 6112, 6121, !0, t);
    case 15:
      return ae(e, "子丑寅卯辰巳午未申酉戌亥", n);
    case 16:
      return ae(e, "甲乙丙丁戊己庚辛壬癸", n);
    case 17:
    case 48:
      return WA(e, "零一二三四五六七八九", Cs, "負", n, zA | jA | _e);
    case 47:
      return WA(e, "零壹貳參肆伍陸柒捌玖", hs, "負", n, He | zA | jA | _e);
    case 42:
      return WA(e, "零一二三四五六七八九", Cs, "负", n, zA | jA | _e);
    case 41:
      return WA(e, "零壹贰叁肆伍陆柒捌玖", hs, "负", n, He | zA | jA | _e);
    case 26:
      return WA(e, "〇一二三四五六七八九", "十百千万", Us, n, 0);
    case 25:
      return WA(e, "零壱弐参四伍六七八九", "拾百千万", Us, n, He | zA | jA);
    case 31:
      return WA(e, "영일이삼사오육칠팔구", "십백천만", br, s, He | zA | jA);
    case 33:
      return WA(e, "零一二三四五六七八九", "十百千萬", br, s, 0);
    case 32:
      return WA(e, "零壹貳參四五六七八九", "拾百千", br, s, He | zA | jA);
    case 18:
      return rA(e, 2406, 2415, !0, t);
    case 20:
      return de(e, 1, 19999, wl, 3, t);
    case 21:
      return rA(e, 2790, 2799, !0, t);
    case 22:
      return rA(e, 2662, 2671, !0, t);
    case 22:
      return de(e, 1, 10999, Ql, 3, t);
    case 23:
      return ae(e, "あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわゐゑをん");
    case 24:
      return ae(e, "いろはにほへとちりぬるをわかよたれそつねならむうゐのおくやまけふこえてあさきゆめみしゑひもせす");
    case 27:
      return rA(e, 3302, 3311, !0, t);
    case 28:
      return ae(e, "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワヰヱヲン", n);
    case 29:
      return ae(e, "イロハニホヘトチリヌルヲワカヨタレソツネナラムウヰノオクヤマケフコエテアサキユメミシヱヒモセス", n);
    case 34:
      return rA(e, 3792, 3801, !0, t);
    case 37:
      return rA(e, 6160, 6169, !0, t);
    case 38:
      return rA(e, 4160, 4169, !0, t);
    case 39:
      return rA(e, 2918, 2927, !0, t);
    case 40:
      return rA(e, 1776, 1785, !0, t);
    case 43:
      return rA(e, 3046, 3055, !0, t);
    case 44:
      return rA(e, 3174, 3183, !0, t);
    case 45:
      return rA(e, 3664, 3673, !0, t);
    case 46:
      return rA(e, 3872, 3881, !0, t);
    case 3:
    default:
      return rA(e, 48, 57, !0, t);
  }
}, mB = "data-html2canvas-ignore", Fs = (
  /** @class */
  (function() {
    function e(A, r, t) {
      if (this.context = A, this.options = t, this.scrolledElements = [], this.referenceElement = r, this.counters = new fl(), this.quoteDepth = 0, !r.ownerDocument)
        throw new Error("Cloned element does not have an owner document");
      this.documentElement = this.cloneNode(r.ownerDocument.documentElement, !1);
    }
    return e.prototype.toIFrame = function(A, r) {
      var t = this, n = Cl(A, r);
      if (!n.contentWindow)
        return Promise.reject("Unable to find iframe window");
      var s = A.defaultView.pageXOffset, B = A.defaultView.pageYOffset, i = n.contentWindow, a = i.document, c = Fl(n).then(function() {
        return UA(t, void 0, void 0, function() {
          var o, g;
          return fA(this, function(f) {
            switch (f.label) {
              case 0:
                return this.scrolledElements.forEach(Hl), i && (i.scrollTo(r.left, r.top), /(iPad|iPhone|iPod)/g.test(navigator.userAgent) && (i.scrollY !== r.top || i.scrollX !== r.left) && (this.context.logger.warn("Unable to restore scroll position for cloned document"), this.context.windowBounds = this.context.windowBounds.add(i.scrollX - r.left, i.scrollY - r.top, 0, 0))), o = this.options.onclone, g = this.clonedReferenceElement, typeof g > "u" ? [2, Promise.reject("Error finding the " + this.referenceElement.nodeName + " in the cloned document")] : a.fonts && a.fonts.ready ? [4, a.fonts.ready] : [3, 2];
              case 1:
                f.sent(), f.label = 2;
              case 2:
                return /(AppleWebKit)/g.test(navigator.userAgent) ? [4, Ul(a)] : [3, 4];
              case 3:
                f.sent(), f.label = 4;
              case 4:
                return typeof o == "function" ? [2, Promise.resolve().then(function() {
                  return o(a, g);
                }).then(function() {
                  return n;
                })] : [2, n];
            }
          });
        });
      });
      return a.open(), a.write(pl(document.doctype) + "<html></html>"), El(this.referenceElement.ownerDocument, s, B), a.replaceChild(a.adoptNode(this.documentElement), a.documentElement), a.close(), c;
    }, e.prototype.createElementClone = function(A) {
      if (en(
        A,
        2
        /* CLONE */
      ))
        debugger;
      if (dB(A))
        return this.createCanvasClone(A);
      if (us(A))
        return this.createVideoClone(A);
      if (gs(A))
        return this.createStyleClone(A);
      var r = A.cloneNode(!1);
      return sn(r) && (sn(A) && A.currentSrc && A.currentSrc !== A.src && (r.src = A.currentSrc, r.srcset = ""), r.loading === "lazy" && (r.loading = "eager")), fs(r) ? this.createCustomElementClone(r) : r;
    }, e.prototype.createCustomElementClone = function(A) {
      var r = document.createElement("html2canvascustomelement");
      return Dr(A.style, r), r;
    }, e.prototype.createStyleClone = function(A) {
      try {
        var r = A.sheet;
        if (r && r.cssRules) {
          var t = [].slice.call(r.cssRules, 0).reduce(function(s, B) {
            return B && typeof B.cssText == "string" ? s + B.cssText : s;
          }, ""), n = A.cloneNode(!1);
          return n.textContent = t, n;
        }
      } catch (s) {
        if (this.context.logger.error("Unable to access cssRules property", s), s.name !== "SecurityError")
          throw s;
      }
      return A.cloneNode(!1);
    }, e.prototype.createCanvasClone = function(A) {
      var r;
      if (this.options.inlineImages && A.ownerDocument) {
        var t = A.ownerDocument.createElement("img");
        try {
          return t.src = A.toDataURL(), t;
        } catch {
          this.context.logger.info("Unable to inline canvas contents, canvas is tainted", A);
        }
      }
      var n = A.cloneNode(!1);
      try {
        n.width = A.width, n.height = A.height;
        var s = A.getContext("2d"), B = n.getContext("2d");
        if (B)
          if (!this.options.allowTaint && s)
            B.putImageData(s.getImageData(0, 0, A.width, A.height), 0, 0);
          else {
            var i = (r = A.getContext("webgl2")) !== null && r !== void 0 ? r : A.getContext("webgl");
            if (i) {
              var a = i.getContextAttributes();
              (a == null ? void 0 : a.preserveDrawingBuffer) === !1 && this.context.logger.warn("Unable to clone WebGL context as it has preserveDrawingBuffer=false", A);
            }
            B.drawImage(A, 0, 0);
          }
        return n;
      } catch {
        this.context.logger.info("Unable to clone canvas as it is tainted", A);
      }
      return n;
    }, e.prototype.createVideoClone = function(A) {
      var r = A.ownerDocument.createElement("canvas");
      r.width = A.offsetWidth, r.height = A.offsetHeight;
      var t = r.getContext("2d");
      try {
        return t && (t.drawImage(A, 0, 0, r.width, r.height), this.options.allowTaint || t.getImageData(0, 0, r.width, r.height)), r;
      } catch {
        this.context.logger.info("Unable to clone video as it is tainted", A);
      }
      var n = A.ownerDocument.createElement("canvas");
      return n.width = A.offsetWidth, n.height = A.offsetHeight, n;
    }, e.prototype.appendChildNode = function(A, r, t) {
      (!ve(r) || !gl(r) && !r.hasAttribute(mB) && (typeof this.options.ignoreElements != "function" || !this.options.ignoreElements(r))) && (!this.options.copyStyles || !ve(r) || !gs(r)) && A.appendChild(this.cloneNode(r, t));
    }, e.prototype.cloneChildNodes = function(A, r, t) {
      for (var n = this, s = A.shadowRoot ? A.shadowRoot.firstChild : A.firstChild; s; s = s.nextSibling)
        if (ve(s) && EB(s) && typeof s.assignedNodes == "function") {
          var B = s.assignedNodes();
          B.length && B.forEach(function(i) {
            return n.appendChildNode(r, i, t);
          });
        } else
          this.appendChildNode(r, s, t);
    }, e.prototype.cloneNode = function(A, r) {
      if (UB(A))
        return document.createTextNode(A.data);
      if (!A.ownerDocument)
        return A.cloneNode(!1);
      var t = A.ownerDocument.defaultView;
      if (t && ve(A) && (nn(A) || Gt(A))) {
        var n = this.createElementClone(A);
        n.style.transitionProperty = "none";
        var s = t.getComputedStyle(A), B = t.getComputedStyle(A, ":before"), i = t.getComputedStyle(A, ":after");
        this.referenceElement === A && nn(n) && (this.clonedReferenceElement = n), Cn(n) && Il(n);
        var a = this.counters.parse(new zn(this.context, s)), c = this.resolvePseudoContent(A, n, B, We.BEFORE);
        fs(A) && (r = !0), us(A) || this.cloneChildNodes(A, n, r), c && n.insertBefore(c, n.firstChild);
        var o = this.resolvePseudoContent(A, n, i, We.AFTER);
        return o && n.appendChild(o), this.counters.pop(a), (s && (this.options.copyStyles || Gt(A)) && !pB(A) || r) && Dr(s, n), (A.scrollTop !== 0 || A.scrollLeft !== 0) && this.scrolledElements.push([n, A.scrollLeft, A.scrollTop]), (kt(A) || Jt(A)) && (kt(n) || Jt(n)) && (n.value = A.value), n;
      }
      return A.cloneNode(!1);
    }, e.prototype.resolvePseudoContent = function(A, r, t, n) {
      var s = this;
      if (t) {
        var B = t.content, i = r.ownerDocument;
        if (!(!i || !B || B === "none" || B === "-moz-alt-content" || t.display === "none")) {
          this.counters.parse(new zn(this.context, t));
          var a = new oc(this.context, t), c = i.createElement("html2canvaspseudoelement");
          Dr(t, c), a.content.forEach(function(g) {
            if (g.type === 0)
              c.appendChild(i.createTextNode(g.value));
            else if (g.type === 22) {
              var f = i.createElement("img");
              f.src = g.value, f.style.opacity = "1", c.appendChild(f);
            } else if (g.type === 18) {
              if (g.name === "attr") {
                var H = g.values.filter(Z);
                H.length && c.appendChild(i.createTextNode(A.getAttribute(H[0].value) || ""));
              } else if (g.name === "counter") {
                var w = g.values.filter(ye), F = w[0], b = w[1];
                if (F && Z(F)) {
                  var K = s.counters.getCounterValue(F.value), y = b && Z(b) ? An.parse(s.context, b.value) : 3;
                  c.appendChild(i.createTextNode(qe(K, y, !1)));
                }
              } else if (g.name === "counters") {
                var V = g.values.filter(ye), F = V[0], M = V[1], b = V[2];
                if (F && Z(F)) {
                  var D = s.counters.getCounterValues(F.value), d = b && Z(b) ? An.parse(s.context, b.value) : 3, Q = M && M.type === 0 ? M.value : "", l = D.map(function(R) {
                    return qe(R, d, !1);
                  }).join(Q);
                  c.appendChild(i.createTextNode(l));
                }
              }
            } else if (g.type === 20)
              switch (g.value) {
                case "open-quote":
                  c.appendChild(i.createTextNode(qn(a.quotes, s.quoteDepth++, !0)));
                  break;
                case "close-quote":
                  c.appendChild(i.createTextNode(qn(a.quotes, --s.quoteDepth, !1)));
                  break;
                default:
                  c.appendChild(i.createTextNode(g.value));
              }
          }), c.className = Bn + " " + an;
          var o = n === We.BEFORE ? " " + Bn : " " + an;
          return Gt(r) ? r.className.baseValue += o : r.className += o, c;
        }
      }
    }, e.destroy = function(A) {
      return A.parentNode ? (A.parentNode.removeChild(A), !0) : !1;
    }, e;
  })()
), We;
(function(e) {
  e[e.BEFORE = 0] = "BEFORE", e[e.AFTER = 1] = "AFTER";
})(We || (We = {}));
var Cl = function(e, A) {
  var r = e.createElement("iframe");
  return r.className = "html2canvas-container", r.style.visibility = "hidden", r.style.position = "fixed", r.style.left = "-10000px", r.style.top = "0px", r.style.border = "0", r.width = A.width.toString(), r.height = A.height.toString(), r.scrolling = "no", r.setAttribute(mB, "true"), e.body.appendChild(r), r;
}, hl = function(e) {
  return new Promise(function(A) {
    if (e.complete) {
      A();
      return;
    }
    if (!e.src) {
      A();
      return;
    }
    e.onload = A, e.onerror = A;
  });
}, Ul = function(e) {
  return Promise.all([].slice.call(e.images, 0).map(hl));
}, Fl = function(e) {
  return new Promise(function(A, r) {
    var t = e.contentWindow;
    if (!t)
      return r("No window assigned for iframe");
    var n = t.document;
    t.onload = e.onload = function() {
      t.onload = e.onload = null;
      var s = setInterval(function() {
        n.body.childNodes.length > 0 && n.readyState === "complete" && (clearInterval(s), A(e));
      }, 50);
    };
  });
}, dl = [
  "all",
  "d",
  "content"
  // Safari shows pseudoelements if content is set
], Dr = function(e, A) {
  for (var r = e.length - 1; r >= 0; r--) {
    var t = e.item(r);
    dl.indexOf(t) === -1 && A.style.setProperty(t, e.getPropertyValue(t));
  }
  return A;
}, pl = function(e) {
  var A = "";
  return e && (A += "<!DOCTYPE ", e.name && (A += e.name), e.internalSubset && (A += e.internalSubset), e.publicId && (A += '"' + e.publicId + '"'), e.systemId && (A += '"' + e.systemId + '"'), A += ">"), A;
}, El = function(e, A, r) {
  e && e.defaultView && (A !== e.defaultView.pageXOffset || r !== e.defaultView.pageYOffset) && e.defaultView.scrollTo(A, r);
}, Hl = function(e) {
  var A = e[0], r = e[1], t = e[2];
  A.scrollLeft = r, A.scrollTop = t;
}, ml = ":before", vl = ":after", Bn = "___html2canvas___pseudoelement_before", an = "___html2canvas___pseudoelement_after", ds = `{
    content: "" !important;
    display: none !important;
}`, Il = function(e) {
  yl(e, "." + Bn + ml + ds + `
         .` + an + vl + ds);
}, yl = function(e, A) {
  var r = e.ownerDocument;
  if (r) {
    var t = r.createElement("style");
    t.textContent = A, e.appendChild(t);
  }
}, vB = (
  /** @class */
  (function() {
    function e() {
    }
    return e.getOrigin = function(A) {
      var r = e._link;
      return r ? (r.href = A, r.href = r.href, r.protocol + r.hostname + r.port) : "about:blank";
    }, e.isSameOrigin = function(A) {
      return e.getOrigin(A) === e._origin;
    }, e.setContext = function(A) {
      e._link = A.document.createElement("a"), e._origin = e.getOrigin(A.location.href);
    }, e._origin = "about:blank", e;
  })()
), Ll = (
  /** @class */
  (function() {
    function e(A, r) {
      this.context = A, this._options = r, this._cache = {};
    }
    return e.prototype.addImage = function(A) {
      var r = Promise.resolve();
      return this.has(A) || (Sr(A) || Dl(A)) && (this._cache[A] = this.loadImage(A)).catch(function() {
      }), r;
    }, e.prototype.match = function(A) {
      return this._cache[A];
    }, e.prototype.loadImage = function(A) {
      return UA(this, void 0, void 0, function() {
        var r, t, n, s, B = this;
        return fA(this, function(i) {
          switch (i.label) {
            case 0:
              return r = vB.isSameOrigin(A), t = !Tr(A) && this._options.useCORS === !0 && cA.SUPPORT_CORS_IMAGES && !r, n = !Tr(A) && !r && !Sr(A) && typeof this._options.proxy == "string" && cA.SUPPORT_CORS_XHR && !t, !r && this._options.allowTaint === !1 && !Tr(A) && !Sr(A) && !n && !t ? [
                2
                /*return*/
              ] : (s = A, n ? [4, this.proxy(s)] : [3, 2]);
            case 1:
              s = i.sent(), i.label = 2;
            case 2:
              return this.context.logger.debug("Added image " + A.substring(0, 256)), [4, new Promise(function(a, c) {
                var o = new Image();
                o.onload = function() {
                  return a(o);
                }, o.onerror = c, (Tl(s) || t) && (o.crossOrigin = "anonymous"), o.src = s, o.complete === !0 && setTimeout(function() {
                  return a(o);
                }, 500), B._options.imageTimeout > 0 && setTimeout(function() {
                  return c("Timed out (" + B._options.imageTimeout + "ms) loading image");
                }, B._options.imageTimeout);
              })];
            case 3:
              return [2, i.sent()];
          }
        });
      });
    }, e.prototype.has = function(A) {
      return typeof this._cache[A] < "u";
    }, e.prototype.keys = function() {
      return Promise.resolve(Object.keys(this._cache));
    }, e.prototype.proxy = function(A) {
      var r = this, t = this._options.proxy;
      if (!t)
        throw new Error("No proxy defined");
      var n = A.substring(0, 256);
      return new Promise(function(s, B) {
        var i = cA.SUPPORT_RESPONSE_TYPE ? "blob" : "text", a = new XMLHttpRequest();
        a.onload = function() {
          if (a.status === 200)
            if (i === "text")
              s(a.response);
            else {
              var g = new FileReader();
              g.addEventListener("load", function() {
                return s(g.result);
              }, !1), g.addEventListener("error", function(f) {
                return B(f);
              }, !1), g.readAsDataURL(a.response);
            }
          else
            B("Failed to proxy resource " + n + " with status code " + a.status);
        }, a.onerror = B;
        var c = t.indexOf("?") > -1 ? "&" : "?";
        if (a.open("GET", "" + t + c + "url=" + encodeURIComponent(A) + "&responseType=" + i), i !== "text" && a instanceof XMLHttpRequest && (a.responseType = i), r._options.imageTimeout) {
          var o = r._options.imageTimeout;
          a.timeout = o, a.ontimeout = function() {
            return B("Timed out (" + o + "ms) proxying " + n);
          };
        }
        a.send();
      });
    }, e;
  })()
), Kl = /^data:image\/svg\+xml/i, xl = /^data:image\/.*;base64,/i, bl = /^data:image\/.*/i, Dl = function(e) {
  return cA.SUPPORT_SVG_DRAWING || !Sl(e);
}, Tr = function(e) {
  return bl.test(e);
}, Tl = function(e) {
  return xl.test(e);
}, Sr = function(e) {
  return e.substr(0, 4) === "blob";
}, Sl = function(e) {
  return e.substr(-3).toLowerCase() === "svg" || Kl.test(e);
}, v = (
  /** @class */
  (function() {
    function e(A, r) {
      this.type = 0, this.x = A, this.y = r;
    }
    return e.prototype.add = function(A, r) {
      return new e(this.x + A, this.y + r);
    }, e;
  })()
), pe = function(e, A, r) {
  return new v(e.x + (A.x - e.x) * r, e.y + (A.y - e.y) * r);
}, Kt = (
  /** @class */
  (function() {
    function e(A, r, t, n) {
      this.type = 1, this.start = A, this.startControl = r, this.endControl = t, this.end = n;
    }
    return e.prototype.subdivide = function(A, r) {
      var t = pe(this.start, this.startControl, A), n = pe(this.startControl, this.endControl, A), s = pe(this.endControl, this.end, A), B = pe(t, n, A), i = pe(n, s, A), a = pe(B, i, A);
      return r ? new e(this.start, t, B, a) : new e(a, i, s, this.end);
    }, e.prototype.add = function(A, r) {
      return new e(this.start.add(A, r), this.startControl.add(A, r), this.endControl.add(A, r), this.end.add(A, r));
    }, e.prototype.reverse = function() {
      return new e(this.end, this.endControl, this.startControl, this.start);
    }, e;
  })()
), yA = function(e) {
  return e.type === 1;
}, Ml = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A) {
      var r = A.styles, t = A.bounds, n = Ve(r.borderTopLeftRadius, t.width, t.height), s = n[0], B = n[1], i = Ve(r.borderTopRightRadius, t.width, t.height), a = i[0], c = i[1], o = Ve(r.borderBottomRightRadius, t.width, t.height), g = o[0], f = o[1], H = Ve(r.borderBottomLeftRadius, t.width, t.height), w = H[0], F = H[1], b = [];
      b.push((s + a) / t.width), b.push((w + g) / t.width), b.push((B + F) / t.height), b.push((c + f) / t.height);
      var K = Math.max.apply(Math, b);
      K > 1 && (s /= K, B /= K, a /= K, c /= K, g /= K, f /= K, w /= K, F /= K);
      var y = t.width - a, V = t.height - f, M = t.width - g, D = t.height - F, d = r.borderTopWidth, Q = r.borderRightWidth, l = r.borderBottomWidth, C = r.borderLeftWidth, m = q(r.paddingTop, A.bounds.width), R = q(r.paddingRight, A.bounds.width), I = q(r.paddingBottom, A.bounds.width), u = q(r.paddingLeft, A.bounds.width);
      this.topLeftBorderDoubleOuterBox = s > 0 || B > 0 ? $(t.left + C / 3, t.top + d / 3, s - C / 3, B - d / 3, W.TOP_LEFT) : new v(t.left + C / 3, t.top + d / 3), this.topRightBorderDoubleOuterBox = s > 0 || B > 0 ? $(t.left + y, t.top + d / 3, a - Q / 3, c - d / 3, W.TOP_RIGHT) : new v(t.left + t.width - Q / 3, t.top + d / 3), this.bottomRightBorderDoubleOuterBox = g > 0 || f > 0 ? $(t.left + M, t.top + V, g - Q / 3, f - l / 3, W.BOTTOM_RIGHT) : new v(t.left + t.width - Q / 3, t.top + t.height - l / 3), this.bottomLeftBorderDoubleOuterBox = w > 0 || F > 0 ? $(t.left + C / 3, t.top + D, w - C / 3, F - l / 3, W.BOTTOM_LEFT) : new v(t.left + C / 3, t.top + t.height - l / 3), this.topLeftBorderDoubleInnerBox = s > 0 || B > 0 ? $(t.left + C * 2 / 3, t.top + d * 2 / 3, s - C * 2 / 3, B - d * 2 / 3, W.TOP_LEFT) : new v(t.left + C * 2 / 3, t.top + d * 2 / 3), this.topRightBorderDoubleInnerBox = s > 0 || B > 0 ? $(t.left + y, t.top + d * 2 / 3, a - Q * 2 / 3, c - d * 2 / 3, W.TOP_RIGHT) : new v(t.left + t.width - Q * 2 / 3, t.top + d * 2 / 3), this.bottomRightBorderDoubleInnerBox = g > 0 || f > 0 ? $(t.left + M, t.top + V, g - Q * 2 / 3, f - l * 2 / 3, W.BOTTOM_RIGHT) : new v(t.left + t.width - Q * 2 / 3, t.top + t.height - l * 2 / 3), this.bottomLeftBorderDoubleInnerBox = w > 0 || F > 0 ? $(t.left + C * 2 / 3, t.top + D, w - C * 2 / 3, F - l * 2 / 3, W.BOTTOM_LEFT) : new v(t.left + C * 2 / 3, t.top + t.height - l * 2 / 3), this.topLeftBorderStroke = s > 0 || B > 0 ? $(t.left + C / 2, t.top + d / 2, s - C / 2, B - d / 2, W.TOP_LEFT) : new v(t.left + C / 2, t.top + d / 2), this.topRightBorderStroke = s > 0 || B > 0 ? $(t.left + y, t.top + d / 2, a - Q / 2, c - d / 2, W.TOP_RIGHT) : new v(t.left + t.width - Q / 2, t.top + d / 2), this.bottomRightBorderStroke = g > 0 || f > 0 ? $(t.left + M, t.top + V, g - Q / 2, f - l / 2, W.BOTTOM_RIGHT) : new v(t.left + t.width - Q / 2, t.top + t.height - l / 2), this.bottomLeftBorderStroke = w > 0 || F > 0 ? $(t.left + C / 2, t.top + D, w - C / 2, F - l / 2, W.BOTTOM_LEFT) : new v(t.left + C / 2, t.top + t.height - l / 2), this.topLeftBorderBox = s > 0 || B > 0 ? $(t.left, t.top, s, B, W.TOP_LEFT) : new v(t.left, t.top), this.topRightBorderBox = a > 0 || c > 0 ? $(t.left + y, t.top, a, c, W.TOP_RIGHT) : new v(t.left + t.width, t.top), this.bottomRightBorderBox = g > 0 || f > 0 ? $(t.left + M, t.top + V, g, f, W.BOTTOM_RIGHT) : new v(t.left + t.width, t.top + t.height), this.bottomLeftBorderBox = w > 0 || F > 0 ? $(t.left, t.top + D, w, F, W.BOTTOM_LEFT) : new v(t.left, t.top + t.height), this.topLeftPaddingBox = s > 0 || B > 0 ? $(t.left + C, t.top + d, Math.max(0, s - C), Math.max(0, B - d), W.TOP_LEFT) : new v(t.left + C, t.top + d), this.topRightPaddingBox = a > 0 || c > 0 ? $(t.left + Math.min(y, t.width - Q), t.top + d, y > t.width + Q ? 0 : Math.max(0, a - Q), Math.max(0, c - d), W.TOP_RIGHT) : new v(t.left + t.width - Q, t.top + d), this.bottomRightPaddingBox = g > 0 || f > 0 ? $(t.left + Math.min(M, t.width - C), t.top + Math.min(V, t.height - l), Math.max(0, g - Q), Math.max(0, f - l), W.BOTTOM_RIGHT) : new v(t.left + t.width - Q, t.top + t.height - l), this.bottomLeftPaddingBox = w > 0 || F > 0 ? $(t.left + C, t.top + Math.min(D, t.height - l), Math.max(0, w - C), Math.max(0, F - l), W.BOTTOM_LEFT) : new v(t.left + C, t.top + t.height - l), this.topLeftContentBox = s > 0 || B > 0 ? $(t.left + C + u, t.top + d + m, Math.max(0, s - (C + u)), Math.max(0, B - (d + m)), W.TOP_LEFT) : new v(t.left + C + u, t.top + d + m), this.topRightContentBox = a > 0 || c > 0 ? $(t.left + Math.min(y, t.width + C + u), t.top + d + m, y > t.width + C + u ? 0 : a - C + u, c - (d + m), W.TOP_RIGHT) : new v(t.left + t.width - (Q + R), t.top + d + m), this.bottomRightContentBox = g > 0 || f > 0 ? $(t.left + Math.min(M, t.width - (C + u)), t.top + Math.min(V, t.height + d + m), Math.max(0, g - (Q + R)), f - (l + I), W.BOTTOM_RIGHT) : new v(t.left + t.width - (Q + R), t.top + t.height - (l + I)), this.bottomLeftContentBox = w > 0 || F > 0 ? $(t.left + C + u, t.top + D, Math.max(0, w - (C + u)), F - (l + I), W.BOTTOM_LEFT) : new v(t.left + C + u, t.top + t.height - (l + I));
    }
    return e;
  })()
), W;
(function(e) {
  e[e.TOP_LEFT = 0] = "TOP_LEFT", e[e.TOP_RIGHT = 1] = "TOP_RIGHT", e[e.BOTTOM_RIGHT = 2] = "BOTTOM_RIGHT", e[e.BOTTOM_LEFT = 3] = "BOTTOM_LEFT";
})(W || (W = {}));
var $ = function(e, A, r, t, n) {
  var s = 4 * ((Math.sqrt(2) - 1) / 3), B = r * s, i = t * s, a = e + r, c = A + t;
  switch (n) {
    case W.TOP_LEFT:
      return new Kt(new v(e, c), new v(e, c - i), new v(a - B, A), new v(a, A));
    case W.TOP_RIGHT:
      return new Kt(new v(e, A), new v(e + B, A), new v(a, c - i), new v(a, c));
    case W.BOTTOM_RIGHT:
      return new Kt(new v(a, A), new v(a, A + i), new v(e + B, c), new v(e, c));
    case W.BOTTOM_LEFT:
    default:
      return new Kt(new v(a, c), new v(a - B, c), new v(e, A + i), new v(e, A));
  }
}, Wt = function(e) {
  return [e.topLeftBorderBox, e.topRightBorderBox, e.bottomRightBorderBox, e.bottomLeftBorderBox];
}, Ol = function(e) {
  return [
    e.topLeftContentBox,
    e.topRightContentBox,
    e.bottomRightContentBox,
    e.bottomLeftContentBox
  ];
}, Yt = function(e) {
  return [
    e.topLeftPaddingBox,
    e.topRightPaddingBox,
    e.bottomRightPaddingBox,
    e.bottomLeftPaddingBox
  ];
}, Rl = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A, r, t) {
      this.offsetX = A, this.offsetY = r, this.matrix = t, this.type = 0, this.target = 6;
    }
    return e;
  })()
), xt = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A, r) {
      this.path = A, this.target = r, this.type = 1;
    }
    return e;
  })()
), Gl = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A) {
      this.opacity = A, this.type = 2, this.target = 6;
    }
    return e;
  })()
), Vl = function(e) {
  return e.type === 0;
}, IB = function(e) {
  return e.type === 1;
}, Nl = function(e) {
  return e.type === 2;
}, ps = function(e, A) {
  return e.length === A.length ? e.some(function(r, t) {
    return r === A[t];
  }) : !1;
}, _l = function(e, A, r, t, n) {
  return e.map(function(s, B) {
    switch (B) {
      case 0:
        return s.add(A, r);
      case 1:
        return s.add(A + t, r);
      case 2:
        return s.add(A + t, r + n);
      case 3:
        return s.add(A, r + n);
    }
    return s;
  });
}, yB = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A) {
      this.element = A, this.inlineLevel = [], this.nonInlineLevel = [], this.negativeZIndex = [], this.zeroOrAutoZIndexOrTransformedOrOpacity = [], this.positiveZIndex = [], this.nonPositionedFloats = [], this.nonPositionedInlineLevel = [];
    }
    return e;
  })()
), LB = (
  /** @class */
  (function() {
    function e(A, r) {
      if (this.container = A, this.parent = r, this.effects = [], this.curves = new Ml(this.container), this.container.styles.opacity < 1 && this.effects.push(new Gl(this.container.styles.opacity)), this.container.styles.transform !== null) {
        var t = this.container.bounds.left + this.container.styles.transformOrigin[0].number, n = this.container.bounds.top + this.container.styles.transformOrigin[1].number, s = this.container.styles.transform;
        this.effects.push(new Rl(t, n, s));
      }
      if (this.container.styles.overflowX !== 0) {
        var B = Wt(this.curves), i = Yt(this.curves);
        ps(B, i) ? this.effects.push(new xt(
          B,
          6
          /* CONTENT */
        )) : (this.effects.push(new xt(
          B,
          2
          /* BACKGROUND_BORDERS */
        )), this.effects.push(new xt(
          i,
          4
          /* CONTENT */
        )));
      }
    }
    return e.prototype.getEffects = function(A) {
      for (var r = [
        2,
        3
        /* FIXED */
      ].indexOf(this.container.styles.position) === -1, t = this.parent, n = this.effects.slice(0); t; ) {
        var s = t.effects.filter(function(a) {
          return !IB(a);
        });
        if (r || t.container.styles.position !== 0 || !t.parent) {
          if (n.unshift.apply(n, s), r = [
            2,
            3
            /* FIXED */
          ].indexOf(t.container.styles.position) === -1, t.container.styles.overflowX !== 0) {
            var B = Wt(t.curves), i = Yt(t.curves);
            ps(B, i) || n.unshift(new xt(
              i,
              6
              /* CONTENT */
            ));
          }
        } else
          n.unshift.apply(n, s);
        t = t.parent;
      }
      return n.filter(function(a) {
        return aA(a.target, A);
      });
    }, e;
  })()
), on = function(e, A, r, t) {
  e.container.elements.forEach(function(n) {
    var s = aA(
      n.flags,
      4
      /* CREATES_REAL_STACKING_CONTEXT */
    ), B = aA(
      n.flags,
      2
      /* CREATES_STACKING_CONTEXT */
    ), i = new LB(n, e);
    aA(
      n.styles.display,
      2048
      /* LIST_ITEM */
    ) && t.push(i);
    var a = aA(
      n.flags,
      8
      /* IS_LIST_OWNER */
    ) ? [] : t;
    if (s || B) {
      var c = s || n.styles.isPositioned() ? r : A, o = new yB(i);
      if (n.styles.isPositioned() || n.styles.opacity < 1 || n.styles.isTransformed()) {
        var g = n.styles.zIndex.order;
        if (g < 0) {
          var f = 0;
          c.negativeZIndex.some(function(w, F) {
            return g > w.element.container.styles.zIndex.order ? (f = F, !1) : f > 0;
          }), c.negativeZIndex.splice(f, 0, o);
        } else if (g > 0) {
          var H = 0;
          c.positiveZIndex.some(function(w, F) {
            return g >= w.element.container.styles.zIndex.order ? (H = F + 1, !1) : H > 0;
          }), c.positiveZIndex.splice(H, 0, o);
        } else
          c.zeroOrAutoZIndexOrTransformedOrOpacity.push(o);
      } else
        n.styles.isFloating() ? c.nonPositionedFloats.push(o) : c.nonPositionedInlineLevel.push(o);
      on(i, o, s ? o : r, a);
    } else
      n.styles.isInlineLevel() ? A.inlineLevel.push(i) : A.nonInlineLevel.push(i), on(i, A, r, a);
    aA(
      n.flags,
      8
      /* IS_LIST_OWNER */
    ) && KB(n, a);
  });
}, KB = function(e, A) {
  for (var r = e instanceof rn ? e.start : 1, t = e instanceof rn ? e.reversed : !1, n = 0; n < A.length; n++) {
    var s = A[n];
    s.container instanceof gB && typeof s.container.value == "number" && s.container.value !== 0 && (r = s.container.value), s.listValue = qe(r, s.container.styles.listStyleType, !0), r += t ? -1 : 1;
  }
}, Pl = function(e) {
  var A = new LB(e, null), r = new yB(A), t = [];
  return on(A, r, r, t), KB(A.container, t), r;
}, Es = function(e, A) {
  switch (A) {
    case 0:
      return KA(e.topLeftBorderBox, e.topLeftPaddingBox, e.topRightBorderBox, e.topRightPaddingBox);
    case 1:
      return KA(e.topRightBorderBox, e.topRightPaddingBox, e.bottomRightBorderBox, e.bottomRightPaddingBox);
    case 2:
      return KA(e.bottomRightBorderBox, e.bottomRightPaddingBox, e.bottomLeftBorderBox, e.bottomLeftPaddingBox);
    case 3:
    default:
      return KA(e.bottomLeftBorderBox, e.bottomLeftPaddingBox, e.topLeftBorderBox, e.topLeftPaddingBox);
  }
}, Xl = function(e, A) {
  switch (A) {
    case 0:
      return KA(e.topLeftBorderBox, e.topLeftBorderDoubleOuterBox, e.topRightBorderBox, e.topRightBorderDoubleOuterBox);
    case 1:
      return KA(e.topRightBorderBox, e.topRightBorderDoubleOuterBox, e.bottomRightBorderBox, e.bottomRightBorderDoubleOuterBox);
    case 2:
      return KA(e.bottomRightBorderBox, e.bottomRightBorderDoubleOuterBox, e.bottomLeftBorderBox, e.bottomLeftBorderDoubleOuterBox);
    case 3:
    default:
      return KA(e.bottomLeftBorderBox, e.bottomLeftBorderDoubleOuterBox, e.topLeftBorderBox, e.topLeftBorderDoubleOuterBox);
  }
}, kl = function(e, A) {
  switch (A) {
    case 0:
      return KA(e.topLeftBorderDoubleInnerBox, e.topLeftPaddingBox, e.topRightBorderDoubleInnerBox, e.topRightPaddingBox);
    case 1:
      return KA(e.topRightBorderDoubleInnerBox, e.topRightPaddingBox, e.bottomRightBorderDoubleInnerBox, e.bottomRightPaddingBox);
    case 2:
      return KA(e.bottomRightBorderDoubleInnerBox, e.bottomRightPaddingBox, e.bottomLeftBorderDoubleInnerBox, e.bottomLeftPaddingBox);
    case 3:
    default:
      return KA(e.bottomLeftBorderDoubleInnerBox, e.bottomLeftPaddingBox, e.topLeftBorderDoubleInnerBox, e.topLeftPaddingBox);
  }
}, Jl = function(e, A) {
  switch (A) {
    case 0:
      return bt(e.topLeftBorderStroke, e.topRightBorderStroke);
    case 1:
      return bt(e.topRightBorderStroke, e.bottomRightBorderStroke);
    case 2:
      return bt(e.bottomRightBorderStroke, e.bottomLeftBorderStroke);
    case 3:
    default:
      return bt(e.bottomLeftBorderStroke, e.topLeftBorderStroke);
  }
}, bt = function(e, A) {
  var r = [];
  return yA(e) ? r.push(e.subdivide(0.5, !1)) : r.push(e), yA(A) ? r.push(A.subdivide(0.5, !0)) : r.push(A), r;
}, KA = function(e, A, r, t) {
  var n = [];
  return yA(e) ? n.push(e.subdivide(0.5, !1)) : n.push(e), yA(r) ? n.push(r.subdivide(0.5, !0)) : n.push(r), yA(t) ? n.push(t.subdivide(0.5, !0).reverse()) : n.push(t), yA(A) ? n.push(A.subdivide(0.5, !1).reverse()) : n.push(A), n;
}, xB = function(e) {
  var A = e.bounds, r = e.styles;
  return A.add(r.borderLeftWidth, r.borderTopWidth, -(r.borderRightWidth + r.borderLeftWidth), -(r.borderTopWidth + r.borderBottomWidth));
}, Zt = function(e) {
  var A = e.styles, r = e.bounds, t = q(A.paddingLeft, r.width), n = q(A.paddingRight, r.width), s = q(A.paddingTop, r.width), B = q(A.paddingBottom, r.width);
  return r.add(t + A.borderLeftWidth, s + A.borderTopWidth, -(A.borderRightWidth + A.borderLeftWidth + t + n), -(A.borderTopWidth + A.borderBottomWidth + s + B));
}, Wl = function(e, A) {
  return e === 0 ? A.bounds : e === 2 ? Zt(A) : xB(A);
}, Yl = function(e, A) {
  return e === 0 ? A.bounds : e === 2 ? Zt(A) : xB(A);
}, Mr = function(e, A, r) {
  var t = Wl(me(e.styles.backgroundOrigin, A), e), n = Yl(me(e.styles.backgroundClip, A), e), s = Zl(me(e.styles.backgroundSize, A), r, t), B = s[0], i = s[1], a = Ve(me(e.styles.backgroundPosition, A), t.width - B, t.height - i), c = ql(me(e.styles.backgroundRepeat, A), a, s, t, n), o = Math.round(t.left + a[0]), g = Math.round(t.top + a[1]);
  return [c, o, g, B, i];
}, Ee = function(e) {
  return Z(e) && e.value === Ie.AUTO;
}, Dt = function(e) {
  return typeof e == "number";
}, Zl = function(e, A, r) {
  var t = A[0], n = A[1], s = A[2], B = e[0], i = e[1];
  if (!B)
    return [0, 0];
  if (sA(B) && i && sA(i))
    return [q(B, r.width), q(i, r.height)];
  var a = Dt(s);
  if (Z(B) && (B.value === Ie.CONTAIN || B.value === Ie.COVER)) {
    if (Dt(s)) {
      var c = r.width / r.height;
      return c < s != (B.value === Ie.COVER) ? [r.width, r.width / s] : [r.height * s, r.height];
    }
    return [r.width, r.height];
  }
  var o = Dt(t), g = Dt(n), f = o || g;
  if (Ee(B) && (!i || Ee(i))) {
    if (o && g)
      return [t, n];
    if (!a && !f)
      return [r.width, r.height];
    if (f && a) {
      var H = o ? t : n * s, w = g ? n : t / s;
      return [H, w];
    }
    var F = o ? t : r.width, b = g ? n : r.height;
    return [F, b];
  }
  if (a) {
    var K = 0, y = 0;
    return sA(B) ? K = q(B, r.width) : sA(i) && (y = q(i, r.height)), Ee(B) ? K = y * s : (!i || Ee(i)) && (y = K / s), [K, y];
  }
  var V = null, M = null;
  if (sA(B) ? V = q(B, r.width) : i && sA(i) && (M = q(i, r.height)), V !== null && (!i || Ee(i)) && (M = o && g ? V / t * n : r.height), M !== null && Ee(B) && (V = o && g ? M / n * t : r.width), V !== null && M !== null)
    return [V, M];
  throw new Error("Unable to calculate background-size for element");
}, me = function(e, A) {
  var r = e[A];
  return typeof r > "u" ? e[0] : r;
}, ql = function(e, A, r, t, n) {
  var s = A[0], B = A[1], i = r[0], a = r[1];
  switch (e) {
    case 2:
      return [
        new v(Math.round(t.left), Math.round(t.top + B)),
        new v(Math.round(t.left + t.width), Math.round(t.top + B)),
        new v(Math.round(t.left + t.width), Math.round(a + t.top + B)),
        new v(Math.round(t.left), Math.round(a + t.top + B))
      ];
    case 3:
      return [
        new v(Math.round(t.left + s), Math.round(t.top)),
        new v(Math.round(t.left + s + i), Math.round(t.top)),
        new v(Math.round(t.left + s + i), Math.round(t.height + t.top)),
        new v(Math.round(t.left + s), Math.round(t.height + t.top))
      ];
    case 1:
      return [
        new v(Math.round(t.left + s), Math.round(t.top + B)),
        new v(Math.round(t.left + s + i), Math.round(t.top + B)),
        new v(Math.round(t.left + s + i), Math.round(t.top + B + a)),
        new v(Math.round(t.left + s), Math.round(t.top + B + a))
      ];
    default:
      return [
        new v(Math.round(n.left), Math.round(n.top)),
        new v(Math.round(n.left + n.width), Math.round(n.top)),
        new v(Math.round(n.left + n.width), Math.round(n.height + n.top)),
        new v(Math.round(n.left), Math.round(n.height + n.top))
      ];
  }
}, zl = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7", Hs = "Hidden Text", jl = (
  /** @class */
  (function() {
    function e(A) {
      this._data = {}, this._document = A;
    }
    return e.prototype.parseMetrics = function(A, r) {
      var t = this._document.createElement("div"), n = this._document.createElement("img"), s = this._document.createElement("span"), B = this._document.body;
      t.style.visibility = "hidden", t.style.fontFamily = A, t.style.fontSize = r, t.style.margin = "0", t.style.padding = "0", t.style.whiteSpace = "nowrap", B.appendChild(t), n.src = zl, n.width = 1, n.height = 1, n.style.margin = "0", n.style.padding = "0", n.style.verticalAlign = "baseline", s.style.fontFamily = A, s.style.fontSize = r, s.style.margin = "0", s.style.padding = "0", s.appendChild(this._document.createTextNode(Hs)), t.appendChild(s), t.appendChild(n);
      var i = n.offsetTop - s.offsetTop + 2;
      t.removeChild(s), t.appendChild(this._document.createTextNode(Hs)), t.style.lineHeight = "normal", n.style.verticalAlign = "super";
      var a = n.offsetTop - t.offsetTop + 2;
      return B.removeChild(t), { baseline: i, middle: a };
    }, e.prototype.getMetrics = function(A, r) {
      var t = A + " " + r;
      return typeof this._data[t] > "u" && (this._data[t] = this.parseMetrics(A, r)), this._data[t];
    }, e;
  })()
), bB = (
  /** @class */
  /* @__PURE__ */ (function() {
    function e(A, r) {
      this.context = A, this.options = r;
    }
    return e;
  })()
), $l = 1e4, Au = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      return n._activeEffects = [], n.canvas = t.canvas ? t.canvas : document.createElement("canvas"), n.ctx = n.canvas.getContext("2d"), t.canvas || (n.canvas.width = Math.floor(t.width * t.scale), n.canvas.height = Math.floor(t.height * t.scale), n.canvas.style.width = t.width + "px", n.canvas.style.height = t.height + "px"), n.fontMetrics = new jl(document), n.ctx.scale(n.options.scale, n.options.scale), n.ctx.translate(-t.x, -t.y), n.ctx.textBaseline = "bottom", n._activeEffects = [], n.context.logger.debug("Canvas renderer initialized (" + t.width + "x" + t.height + ") with scale " + t.scale), n;
    }
    return A.prototype.applyEffects = function(r) {
      for (var t = this; this._activeEffects.length; )
        this.popEffect();
      r.forEach(function(n) {
        return t.applyEffect(n);
      });
    }, A.prototype.applyEffect = function(r) {
      this.ctx.save(), Nl(r) && (this.ctx.globalAlpha = r.opacity), Vl(r) && (this.ctx.translate(r.offsetX, r.offsetY), this.ctx.transform(r.matrix[0], r.matrix[1], r.matrix[2], r.matrix[3], r.matrix[4], r.matrix[5]), this.ctx.translate(-r.offsetX, -r.offsetY)), IB(r) && (this.path(r.path), this.ctx.clip()), this._activeEffects.push(r);
    }, A.prototype.popEffect = function() {
      this._activeEffects.pop(), this.ctx.restore();
    }, A.prototype.renderStack = function(r) {
      return UA(this, void 0, void 0, function() {
        var t;
        return fA(this, function(n) {
          switch (n.label) {
            case 0:
              return t = r.element.container.styles, t.isVisible() ? [4, this.renderStackContent(r)] : [3, 2];
            case 1:
              n.sent(), n.label = 2;
            case 2:
              return [
                2
                /*return*/
              ];
          }
        });
      });
    }, A.prototype.renderNode = function(r) {
      return UA(this, void 0, void 0, function() {
        return fA(this, function(t) {
          switch (t.label) {
            case 0:
              if (aA(
                r.container.flags,
                16
                /* DEBUG_RENDER */
              ))
                debugger;
              return r.container.styles.isVisible() ? [4, this.renderNodeBackgroundAndBorders(r)] : [3, 3];
            case 1:
              return t.sent(), [4, this.renderNodeContent(r)];
            case 2:
              t.sent(), t.label = 3;
            case 3:
              return [
                2
                /*return*/
              ];
          }
        });
      });
    }, A.prototype.renderTextWithLetterSpacing = function(r, t, n) {
      var s = this;
      if (t === 0)
        this.ctx.fillText(r.text, r.bounds.left, r.bounds.top + n);
      else {
        var B = Qn(r.text);
        B.reduce(function(i, a) {
          return s.ctx.fillText(a, i, r.bounds.top + n), i + s.ctx.measureText(a).width;
        }, r.bounds.left);
      }
    }, A.prototype.createFontStyle = function(r) {
      var t = r.fontVariant.filter(function(B) {
        return B === "normal" || B === "small-caps";
      }).join(""), n = su(r.fontFamily).join(", "), s = je(r.fontSize) ? "" + r.fontSize.number + r.fontSize.unit : r.fontSize.number + "px";
      return [
        [r.fontStyle, t, r.fontWeight, s, n].join(" "),
        n,
        s
      ];
    }, A.prototype.renderTextNode = function(r, t) {
      return UA(this, void 0, void 0, function() {
        var n, s, B, i, a, c, o, g, f = this;
        return fA(this, function(H) {
          return n = this.createFontStyle(t), s = n[0], B = n[1], i = n[2], this.ctx.font = s, this.ctx.direction = t.direction === 1 ? "rtl" : "ltr", this.ctx.textAlign = "left", this.ctx.textBaseline = "alphabetic", a = this.fontMetrics.getMetrics(B, i), c = a.baseline, o = a.middle, g = t.paintOrder, r.textBounds.forEach(function(w) {
            g.forEach(function(F) {
              switch (F) {
                case 0:
                  f.ctx.fillStyle = oA(t.color), f.renderTextWithLetterSpacing(w, t.letterSpacing, c);
                  var b = t.textShadow;
                  b.length && w.text.trim().length && (b.slice(0).reverse().forEach(function(K) {
                    f.ctx.shadowColor = oA(K.color), f.ctx.shadowOffsetX = K.offsetX.number * f.options.scale, f.ctx.shadowOffsetY = K.offsetY.number * f.options.scale, f.ctx.shadowBlur = K.blur.number, f.renderTextWithLetterSpacing(w, t.letterSpacing, c);
                  }), f.ctx.shadowColor = "", f.ctx.shadowOffsetX = 0, f.ctx.shadowOffsetY = 0, f.ctx.shadowBlur = 0), t.textDecorationLine.length && (f.ctx.fillStyle = oA(t.textDecorationColor || t.color), t.textDecorationLine.forEach(function(K) {
                    switch (K) {
                      case 1:
                        f.ctx.fillRect(w.bounds.left, Math.round(w.bounds.top + c), w.bounds.width, 1);
                        break;
                      case 2:
                        f.ctx.fillRect(w.bounds.left, Math.round(w.bounds.top), w.bounds.width, 1);
                        break;
                      case 3:
                        f.ctx.fillRect(w.bounds.left, Math.ceil(w.bounds.top + o), w.bounds.width, 1);
                        break;
                    }
                  }));
                  break;
                case 1:
                  t.webkitTextStrokeWidth && w.text.trim().length && (f.ctx.strokeStyle = oA(t.webkitTextStrokeColor), f.ctx.lineWidth = t.webkitTextStrokeWidth, f.ctx.lineJoin = window.chrome ? "miter" : "round", f.ctx.strokeText(w.text, w.bounds.left, w.bounds.top + c)), f.ctx.strokeStyle = "", f.ctx.lineWidth = 0, f.ctx.lineJoin = "miter";
                  break;
              }
            });
          }), [
            2
            /*return*/
          ];
        });
      });
    }, A.prototype.renderReplacedElement = function(r, t, n) {
      if (n && r.intrinsicWidth > 0 && r.intrinsicHeight > 0) {
        var s = Zt(r), B = Yt(t);
        this.path(B), this.ctx.save(), this.ctx.clip(), this.ctx.drawImage(n, 0, 0, r.intrinsicWidth, r.intrinsicHeight, s.left, s.top, s.width, s.height), this.ctx.restore();
      }
    }, A.prototype.renderNodeContent = function(r) {
      return UA(this, void 0, void 0, function() {
        var t, n, s, B, i, a, y, y, c, o, g, f, M, H, w, D, F, b, K, y, V, M, D;
        return fA(this, function(d) {
          switch (d.label) {
            case 0:
              this.applyEffects(r.getEffects(
                4
                /* CONTENT */
              )), t = r.container, n = r.curves, s = t.styles, B = 0, i = t.textNodes, d.label = 1;
            case 1:
              return B < i.length ? (a = i[B], [4, this.renderTextNode(a, s)]) : [3, 4];
            case 2:
              d.sent(), d.label = 3;
            case 3:
              return B++, [3, 1];
            case 4:
              if (!(t instanceof cB)) return [3, 8];
              d.label = 5;
            case 5:
              return d.trys.push([5, 7, , 8]), [4, this.context.cache.match(t.src)];
            case 6:
              return y = d.sent(), this.renderReplacedElement(t, n, y), [3, 8];
            case 7:
              return d.sent(), this.context.logger.error("Error loading image " + t.src), [3, 8];
            case 8:
              if (t instanceof lB && this.renderReplacedElement(t, n, t.canvas), !(t instanceof uB)) return [3, 12];
              d.label = 9;
            case 9:
              return d.trys.push([9, 11, , 12]), [4, this.context.cache.match(t.svg)];
            case 10:
              return y = d.sent(), this.renderReplacedElement(t, n, y), [3, 12];
            case 11:
              return d.sent(), this.context.logger.error("Error loading svg " + t.svg.substring(0, 255)), [3, 12];
            case 12:
              return t instanceof wB && t.tree ? (c = new A(this.context, {
                scale: this.options.scale,
                backgroundColor: t.backgroundColor,
                x: 0,
                y: 0,
                width: t.width,
                height: t.height
              }), [4, c.render(t.tree)]) : [3, 14];
            case 13:
              o = d.sent(), t.width && t.height && this.ctx.drawImage(o, 0, 0, t.width, t.height, t.bounds.left, t.bounds.top, t.bounds.width, t.bounds.height), d.label = 14;
            case 14:
              if (t instanceof wn && (g = Math.min(t.bounds.width, t.bounds.height), t.type === Pt ? t.checked && (this.ctx.save(), this.path([
                new v(t.bounds.left + g * 0.39363, t.bounds.top + g * 0.79),
                new v(t.bounds.left + g * 0.16, t.bounds.top + g * 0.5549),
                new v(t.bounds.left + g * 0.27347, t.bounds.top + g * 0.44071),
                new v(t.bounds.left + g * 0.39694, t.bounds.top + g * 0.5649),
                new v(t.bounds.left + g * 0.72983, t.bounds.top + g * 0.23),
                new v(t.bounds.left + g * 0.84, t.bounds.top + g * 0.34085),
                new v(t.bounds.left + g * 0.39363, t.bounds.top + g * 0.79)
              ]), this.ctx.fillStyle = oA(ls), this.ctx.fill(), this.ctx.restore()) : t.type === Xt && t.checked && (this.ctx.save(), this.ctx.beginPath(), this.ctx.arc(t.bounds.left + g / 2, t.bounds.top + g / 2, g / 4, 0, Math.PI * 2, !0), this.ctx.fillStyle = oA(ls), this.ctx.fill(), this.ctx.restore())), eu(t) && t.value.length) {
                switch (f = this.createFontStyle(s), M = f[0], H = f[1], w = this.fontMetrics.getMetrics(M, H).baseline, this.ctx.font = M, this.ctx.fillStyle = oA(s.color), this.ctx.textBaseline = "alphabetic", this.ctx.textAlign = ru(t.styles.textAlign), D = Zt(t), F = 0, t.styles.textAlign) {
                  case 1:
                    F += D.width / 2;
                    break;
                  case 2:
                    F += D.width;
                    break;
                }
                b = D.add(F, 0, 0, -D.height / 2 + 1), this.ctx.save(), this.path([
                  new v(D.left, D.top),
                  new v(D.left + D.width, D.top),
                  new v(D.left + D.width, D.top + D.height),
                  new v(D.left, D.top + D.height)
                ]), this.ctx.clip(), this.renderTextWithLetterSpacing(new Je(t.value, b), s.letterSpacing, w), this.ctx.restore(), this.ctx.textBaseline = "alphabetic", this.ctx.textAlign = "left";
              }
              if (!aA(
                t.styles.display,
                2048
                /* LIST_ITEM */
              )) return [3, 20];
              if (t.styles.listStyleImage === null) return [3, 19];
              if (K = t.styles.listStyleImage, K.type !== 0) return [3, 18];
              y = void 0, V = K.url, d.label = 15;
            case 15:
              return d.trys.push([15, 17, , 18]), [4, this.context.cache.match(V)];
            case 16:
              return y = d.sent(), this.ctx.drawImage(y, t.bounds.left - (y.width + 10), t.bounds.top), [3, 18];
            case 17:
              return d.sent(), this.context.logger.error("Error loading list-style-image " + V), [3, 18];
            case 18:
              return [3, 20];
            case 19:
              r.listValue && t.styles.listStyleType !== -1 && (M = this.createFontStyle(s)[0], this.ctx.font = M, this.ctx.fillStyle = oA(s.color), this.ctx.textBaseline = "middle", this.ctx.textAlign = "right", D = new ZA(t.bounds.left, t.bounds.top + q(t.styles.paddingTop, t.bounds.width), t.bounds.width, Yn(s.lineHeight, s.fontSize.number) / 2 + 1), this.renderTextWithLetterSpacing(new Je(r.listValue, D), s.letterSpacing, Yn(s.lineHeight, s.fontSize.number) / 2 + 2), this.ctx.textBaseline = "bottom", this.ctx.textAlign = "left"), d.label = 20;
            case 20:
              return [
                2
                /*return*/
              ];
          }
        });
      });
    }, A.prototype.renderStackContent = function(r) {
      return UA(this, void 0, void 0, function() {
        var t, n, K, s, B, K, i, a, K, c, o, K, g, f, K, H, w, K, F, b, K;
        return fA(this, function(y) {
          switch (y.label) {
            case 0:
              if (aA(
                r.element.container.flags,
                16
                /* DEBUG_RENDER */
              ))
                debugger;
              return [4, this.renderNodeBackgroundAndBorders(r.element)];
            case 1:
              y.sent(), t = 0, n = r.negativeZIndex, y.label = 2;
            case 2:
              return t < n.length ? (K = n[t], [4, this.renderStack(K)]) : [3, 5];
            case 3:
              y.sent(), y.label = 4;
            case 4:
              return t++, [3, 2];
            case 5:
              return [4, this.renderNodeContent(r.element)];
            case 6:
              y.sent(), s = 0, B = r.nonInlineLevel, y.label = 7;
            case 7:
              return s < B.length ? (K = B[s], [4, this.renderNode(K)]) : [3, 10];
            case 8:
              y.sent(), y.label = 9;
            case 9:
              return s++, [3, 7];
            case 10:
              i = 0, a = r.nonPositionedFloats, y.label = 11;
            case 11:
              return i < a.length ? (K = a[i], [4, this.renderStack(K)]) : [3, 14];
            case 12:
              y.sent(), y.label = 13;
            case 13:
              return i++, [3, 11];
            case 14:
              c = 0, o = r.nonPositionedInlineLevel, y.label = 15;
            case 15:
              return c < o.length ? (K = o[c], [4, this.renderStack(K)]) : [3, 18];
            case 16:
              y.sent(), y.label = 17;
            case 17:
              return c++, [3, 15];
            case 18:
              g = 0, f = r.inlineLevel, y.label = 19;
            case 19:
              return g < f.length ? (K = f[g], [4, this.renderNode(K)]) : [3, 22];
            case 20:
              y.sent(), y.label = 21;
            case 21:
              return g++, [3, 19];
            case 22:
              H = 0, w = r.zeroOrAutoZIndexOrTransformedOrOpacity, y.label = 23;
            case 23:
              return H < w.length ? (K = w[H], [4, this.renderStack(K)]) : [3, 26];
            case 24:
              y.sent(), y.label = 25;
            case 25:
              return H++, [3, 23];
            case 26:
              F = 0, b = r.positiveZIndex, y.label = 27;
            case 27:
              return F < b.length ? (K = b[F], [4, this.renderStack(K)]) : [3, 30];
            case 28:
              y.sent(), y.label = 29;
            case 29:
              return F++, [3, 27];
            case 30:
              return [
                2
                /*return*/
              ];
          }
        });
      });
    }, A.prototype.mask = function(r) {
      this.ctx.beginPath(), this.ctx.moveTo(0, 0), this.ctx.lineTo(this.canvas.width, 0), this.ctx.lineTo(this.canvas.width, this.canvas.height), this.ctx.lineTo(0, this.canvas.height), this.ctx.lineTo(0, 0), this.formatPath(r.slice(0).reverse()), this.ctx.closePath();
    }, A.prototype.path = function(r) {
      this.ctx.beginPath(), this.formatPath(r), this.ctx.closePath();
    }, A.prototype.formatPath = function(r) {
      var t = this;
      r.forEach(function(n, s) {
        var B = yA(n) ? n.start : n;
        s === 0 ? t.ctx.moveTo(B.x, B.y) : t.ctx.lineTo(B.x, B.y), yA(n) && t.ctx.bezierCurveTo(n.startControl.x, n.startControl.y, n.endControl.x, n.endControl.y, n.end.x, n.end.y);
      });
    }, A.prototype.renderRepeat = function(r, t, n, s) {
      this.path(r), this.ctx.fillStyle = t, this.ctx.translate(n, s), this.ctx.fill(), this.ctx.translate(-n, -s);
    }, A.prototype.resizeImage = function(r, t, n) {
      var s;
      if (r.width === t && r.height === n)
        return r;
      var B = (s = this.canvas.ownerDocument) !== null && s !== void 0 ? s : document, i = B.createElement("canvas");
      i.width = Math.max(1, t), i.height = Math.max(1, n);
      var a = i.getContext("2d");
      return a.drawImage(r, 0, 0, r.width, r.height, 0, 0, t, n), i;
    }, A.prototype.renderBackgroundImage = function(r) {
      return UA(this, void 0, void 0, function() {
        var t, n, s, B, i, a;
        return fA(this, function(c) {
          switch (c.label) {
            case 0:
              t = r.styles.backgroundImage.length - 1, n = function(o) {
                var g, f, H, m, p, T, u, U, l, w, m, p, T, u, U, F, b, K, y, V, M, D, d, Q, l, C, m, R, I, u, U, x, p, T, X, z, S, k, G, E, _, BA;
                return fA(this, function(uA) {
                  switch (uA.label) {
                    case 0:
                      if (o.type !== 0) return [3, 5];
                      g = void 0, f = o.url, uA.label = 1;
                    case 1:
                      return uA.trys.push([1, 3, , 4]), [4, s.context.cache.match(f)];
                    case 2:
                      return g = uA.sent(), [3, 4];
                    case 3:
                      return uA.sent(), s.context.logger.error("Error loading background-image " + f), [3, 4];
                    case 4:
                      return g && (H = Mr(r, t, [
                        g.width,
                        g.height,
                        g.width / g.height
                      ]), m = H[0], p = H[1], T = H[2], u = H[3], U = H[4], l = s.ctx.createPattern(s.resizeImage(g, u, U), "repeat"), s.renderRepeat(m, l, p, T)), [3, 6];
                    case 5:
                      Ga(o) ? (w = Mr(r, t, [null, null, null]), m = w[0], p = w[1], T = w[2], u = w[3], U = w[4], F = Ta(o.angle, u, U), b = F[0], K = F[1], y = F[2], V = F[3], M = F[4], D = document.createElement("canvas"), D.width = u, D.height = U, d = D.getContext("2d"), Q = d.createLinearGradient(K, V, y, M), Jn(o.stops, b).forEach(function(wA) {
                        return Q.addColorStop(wA.stop, oA(wA.color));
                      }), d.fillStyle = Q, d.fillRect(0, 0, u, U), u > 0 && U > 0 && (l = s.ctx.createPattern(D, "repeat"), s.renderRepeat(m, l, p, T))) : Va(o) && (C = Mr(r, t, [
                        null,
                        null,
                        null
                      ]), m = C[0], R = C[1], I = C[2], u = C[3], U = C[4], x = o.position.length === 0 ? [un] : o.position, p = q(x[0], u), T = q(x[x.length - 1], U), X = Sa(o, p, T, u, U), z = X[0], S = X[1], z > 0 && S > 0 && (k = s.ctx.createRadialGradient(R + p, I + T, 0, R + p, I + T, z), Jn(o.stops, z * 2).forEach(function(wA) {
                        return k.addColorStop(wA.stop, oA(wA.color));
                      }), s.path(m), s.ctx.fillStyle = k, z !== S ? (G = r.bounds.left + 0.5 * r.bounds.width, E = r.bounds.top + 0.5 * r.bounds.height, _ = S / z, BA = 1 / _, s.ctx.save(), s.ctx.translate(G, E), s.ctx.transform(1, 0, 0, _, 0, 0), s.ctx.translate(-G, -E), s.ctx.fillRect(R, BA * (I - E) + E, u, U * BA), s.ctx.restore()) : s.ctx.fill())), uA.label = 6;
                    case 6:
                      return t--, [
                        2
                        /*return*/
                      ];
                  }
                });
              }, s = this, B = 0, i = r.styles.backgroundImage.slice(0).reverse(), c.label = 1;
            case 1:
              return B < i.length ? (a = i[B], [5, n(a)]) : [3, 4];
            case 2:
              c.sent(), c.label = 3;
            case 3:
              return B++, [3, 1];
            case 4:
              return [
                2
                /*return*/
              ];
          }
        });
      });
    }, A.prototype.renderSolidBorder = function(r, t, n) {
      return UA(this, void 0, void 0, function() {
        return fA(this, function(s) {
          return this.path(Es(n, t)), this.ctx.fillStyle = oA(r), this.ctx.fill(), [
            2
            /*return*/
          ];
        });
      });
    }, A.prototype.renderDoubleBorder = function(r, t, n, s) {
      return UA(this, void 0, void 0, function() {
        var B, i;
        return fA(this, function(a) {
          switch (a.label) {
            case 0:
              return t < 3 ? [4, this.renderSolidBorder(r, n, s)] : [3, 2];
            case 1:
              return a.sent(), [
                2
                /*return*/
              ];
            case 2:
              return B = Xl(s, n), this.path(B), this.ctx.fillStyle = oA(r), this.ctx.fill(), i = kl(s, n), this.path(i), this.ctx.fill(), [
                2
                /*return*/
              ];
          }
        });
      });
    }, A.prototype.renderNodeBackgroundAndBorders = function(r) {
      return UA(this, void 0, void 0, function() {
        var t, n, s, B, i, a, c, o, g = this;
        return fA(this, function(f) {
          switch (f.label) {
            case 0:
              return this.applyEffects(r.getEffects(
                2
                /* BACKGROUND_BORDERS */
              )), t = r.container.styles, n = !ne(t.backgroundColor) || t.backgroundImage.length, s = [
                { style: t.borderTopStyle, color: t.borderTopColor, width: t.borderTopWidth },
                { style: t.borderRightStyle, color: t.borderRightColor, width: t.borderRightWidth },
                { style: t.borderBottomStyle, color: t.borderBottomColor, width: t.borderBottomWidth },
                { style: t.borderLeftStyle, color: t.borderLeftColor, width: t.borderLeftWidth }
              ], B = tu(me(t.backgroundClip, 0), r.curves), n || t.boxShadow.length ? (this.ctx.save(), this.path(B), this.ctx.clip(), ne(t.backgroundColor) || (this.ctx.fillStyle = oA(t.backgroundColor), this.ctx.fill()), [4, this.renderBackgroundImage(r.container)]) : [3, 2];
            case 1:
              f.sent(), this.ctx.restore(), t.boxShadow.slice(0).reverse().forEach(function(H) {
                g.ctx.save();
                var w = Wt(r.curves), F = H.inset ? 0 : $l, b = _l(w, -F + (H.inset ? 1 : -1) * H.spread.number, (H.inset ? 1 : -1) * H.spread.number, H.spread.number * (H.inset ? -2 : 2), H.spread.number * (H.inset ? -2 : 2));
                H.inset ? (g.path(w), g.ctx.clip(), g.mask(b)) : (g.mask(w), g.ctx.clip(), g.path(b)), g.ctx.shadowOffsetX = H.offsetX.number + F, g.ctx.shadowOffsetY = H.offsetY.number, g.ctx.shadowColor = oA(H.color), g.ctx.shadowBlur = H.blur.number, g.ctx.fillStyle = H.inset ? oA(H.color) : "rgba(0,0,0,1)", g.ctx.fill(), g.ctx.restore();
              }), f.label = 2;
            case 2:
              i = 0, a = 0, c = s, f.label = 3;
            case 3:
              return a < c.length ? (o = c[a], o.style !== 0 && !ne(o.color) && o.width > 0 ? o.style !== 2 ? [3, 5] : [4, this.renderDashedDottedBorder(
                o.color,
                o.width,
                i,
                r.curves,
                2
                /* DASHED */
              )] : [3, 11]) : [3, 13];
            case 4:
              return f.sent(), [3, 11];
            case 5:
              return o.style !== 3 ? [3, 7] : [4, this.renderDashedDottedBorder(
                o.color,
                o.width,
                i,
                r.curves,
                3
                /* DOTTED */
              )];
            case 6:
              return f.sent(), [3, 11];
            case 7:
              return o.style !== 4 ? [3, 9] : [4, this.renderDoubleBorder(o.color, o.width, i, r.curves)];
            case 8:
              return f.sent(), [3, 11];
            case 9:
              return [4, this.renderSolidBorder(o.color, i, r.curves)];
            case 10:
              f.sent(), f.label = 11;
            case 11:
              i++, f.label = 12;
            case 12:
              return a++, [3, 3];
            case 13:
              return [
                2
                /*return*/
              ];
          }
        });
      });
    }, A.prototype.renderDashedDottedBorder = function(r, t, n, s, B) {
      return UA(this, void 0, void 0, function() {
        var i, a, c, o, g, f, H, w, F, b, K, y, V, M, D, d, D, d;
        return fA(this, function(Q) {
          return this.ctx.save(), i = Jl(s, n), a = Es(s, n), B === 2 && (this.path(a), this.ctx.clip()), yA(a[0]) ? (c = a[0].start.x, o = a[0].start.y) : (c = a[0].x, o = a[0].y), yA(a[1]) ? (g = a[1].end.x, f = a[1].end.y) : (g = a[1].x, f = a[1].y), n === 0 || n === 2 ? H = Math.abs(c - g) : H = Math.abs(o - f), this.ctx.beginPath(), B === 3 ? this.formatPath(i) : this.formatPath(a.slice(0, 2)), w = t < 3 ? t * 3 : t * 2, F = t < 3 ? t * 2 : t, B === 3 && (w = t, F = t), b = !0, H <= w * 2 ? b = !1 : H <= w * 2 + F ? (K = H / (2 * w + F), w *= K, F *= K) : (y = Math.floor((H + F) / (w + F)), V = (H - y * w) / (y - 1), M = (H - (y + 1) * w) / y, F = M <= 0 || Math.abs(F - V) < Math.abs(F - M) ? V : M), b && (B === 3 ? this.ctx.setLineDash([0, w + F]) : this.ctx.setLineDash([w, F])), B === 3 ? (this.ctx.lineCap = "round", this.ctx.lineWidth = t) : this.ctx.lineWidth = t * 2 + 1.1, this.ctx.strokeStyle = oA(r), this.ctx.stroke(), this.ctx.setLineDash([]), B === 2 && (yA(a[0]) && (D = a[3], d = a[0], this.ctx.beginPath(), this.formatPath([new v(D.end.x, D.end.y), new v(d.start.x, d.start.y)]), this.ctx.stroke()), yA(a[1]) && (D = a[1], d = a[2], this.ctx.beginPath(), this.formatPath([new v(D.end.x, D.end.y), new v(d.start.x, d.start.y)]), this.ctx.stroke())), this.ctx.restore(), [
            2
            /*return*/
          ];
        });
      });
    }, A.prototype.render = function(r) {
      return UA(this, void 0, void 0, function() {
        var t;
        return fA(this, function(n) {
          switch (n.label) {
            case 0:
              return this.options.backgroundColor && (this.ctx.fillStyle = oA(this.options.backgroundColor), this.ctx.fillRect(this.options.x, this.options.y, this.options.width, this.options.height)), t = Pl(r), [4, this.renderStack(t)];
            case 1:
              return n.sent(), this.applyEffects([]), [2, this.canvas];
          }
        });
      });
    }, A;
  })(bB)
), eu = function(e) {
  return e instanceof QB || e instanceof fB ? !0 : e instanceof wn && e.type !== Xt && e.type !== Pt;
}, tu = function(e, A) {
  switch (e) {
    case 0:
      return Wt(A);
    case 2:
      return Ol(A);
    case 1:
    default:
      return Yt(A);
  }
}, ru = function(e) {
  switch (e) {
    case 1:
      return "center";
    case 2:
      return "right";
    case 0:
    default:
      return "left";
  }
}, nu = ["-apple-system", "system-ui"], su = function(e) {
  return /iPhone OS 15_(0|1)/.test(window.navigator.userAgent) ? e.filter(function(A) {
    return nu.indexOf(A) === -1;
  }) : e;
}, Bu = (
  /** @class */
  (function(e) {
    MA(A, e);
    function A(r, t) {
      var n = e.call(this, r, t) || this;
      return n.canvas = t.canvas ? t.canvas : document.createElement("canvas"), n.ctx = n.canvas.getContext("2d"), n.options = t, n.canvas.width = Math.floor(t.width * t.scale), n.canvas.height = Math.floor(t.height * t.scale), n.canvas.style.width = t.width + "px", n.canvas.style.height = t.height + "px", n.ctx.scale(n.options.scale, n.options.scale), n.ctx.translate(-t.x, -t.y), n.context.logger.debug("EXPERIMENTAL ForeignObject renderer initialized (" + t.width + "x" + t.height + " at " + t.x + "," + t.y + ") with scale " + t.scale), n;
    }
    return A.prototype.render = function(r) {
      return UA(this, void 0, void 0, function() {
        var t, n;
        return fA(this, function(s) {
          switch (s.label) {
            case 0:
              return t = tn(this.options.width * this.options.scale, this.options.height * this.options.scale, this.options.scale, this.options.scale, r), [4, iu(t)];
            case 1:
              return n = s.sent(), this.options.backgroundColor && (this.ctx.fillStyle = oA(this.options.backgroundColor), this.ctx.fillRect(0, 0, this.options.width * this.options.scale, this.options.height * this.options.scale)), this.ctx.drawImage(n, -this.options.x * this.options.scale, -this.options.y * this.options.scale), [2, this.canvas];
          }
        });
      });
    }, A;
  })(bB)
), iu = function(e) {
  return new Promise(function(A, r) {
    var t = new Image();
    t.onload = function() {
      A(t);
    }, t.onerror = r, t.src = "data:image/svg+xml;charset=utf-8," + encodeURIComponent(new XMLSerializer().serializeToString(e));
  });
}, au = (
  /** @class */
  (function() {
    function e(A) {
      var r = A.id, t = A.enabled;
      this.id = r, this.enabled = t, this.start = Date.now();
    }
    return e.prototype.debug = function() {
      for (var A = [], r = 0; r < arguments.length; r++)
        A[r] = arguments[r];
      this.enabled && (typeof window < "u" && window.console && typeof console.debug == "function" ? console.debug.apply(console, lt([this.id, this.getTime() + "ms"], A)) : this.info.apply(this, A));
    }, e.prototype.getTime = function() {
      return Date.now() - this.start;
    }, e.prototype.info = function() {
      for (var A = [], r = 0; r < arguments.length; r++)
        A[r] = arguments[r];
      this.enabled && typeof window < "u" && window.console && typeof console.info == "function" && console.info.apply(console, lt([this.id, this.getTime() + "ms"], A));
    }, e.prototype.warn = function() {
      for (var A = [], r = 0; r < arguments.length; r++)
        A[r] = arguments[r];
      this.enabled && (typeof window < "u" && window.console && typeof console.warn == "function" ? console.warn.apply(console, lt([this.id, this.getTime() + "ms"], A)) : this.info.apply(this, A));
    }, e.prototype.error = function() {
      for (var A = [], r = 0; r < arguments.length; r++)
        A[r] = arguments[r];
      this.enabled && (typeof window < "u" && window.console && typeof console.error == "function" ? console.error.apply(console, lt([this.id, this.getTime() + "ms"], A)) : this.info.apply(this, A));
    }, e.instances = {}, e;
  })()
), ou = (
  /** @class */
  (function() {
    function e(A, r) {
      var t;
      this.windowBounds = r, this.instanceName = "#" + e.instanceCount++, this.logger = new au({ id: this.instanceName, enabled: A.logging }), this.cache = (t = A.cache) !== null && t !== void 0 ? t : new Ll(this, A);
    }
    return e.instanceCount = 1, e;
  })()
), ms = function(e, A) {
  return A === void 0 && (A = {}), cu(e, A);
};
typeof window < "u" && vB.setContext(window);
var cu = function(e, A) {
  return UA(void 0, void 0, void 0, function() {
    var r, t, n, s, B, i, a, c, o, g, f, H, w, F, b, K, y, V, M, D, Q, d, Q, l, C, m, R, I, u, U, x, p, T, X, z, S, k, G, E, _;
    return fA(this, function(BA) {
      switch (BA.label) {
        case 0:
          if (!e || typeof e != "object")
            return [2, Promise.reject("Invalid element provided as first argument")];
          if (r = e.ownerDocument, !r)
            throw new Error("Element is not attached to a Document");
          if (t = r.defaultView, !t)
            throw new Error("Document is not attached to a Window");
          return n = {
            allowTaint: (l = A.allowTaint) !== null && l !== void 0 ? l : !1,
            imageTimeout: (C = A.imageTimeout) !== null && C !== void 0 ? C : 15e3,
            proxy: A.proxy,
            useCORS: (m = A.useCORS) !== null && m !== void 0 ? m : !1
          }, s = Nr({ logging: (R = A.logging) !== null && R !== void 0 ? R : !0, cache: A.cache }, n), B = {
            windowWidth: (I = A.windowWidth) !== null && I !== void 0 ? I : t.innerWidth,
            windowHeight: (u = A.windowHeight) !== null && u !== void 0 ? u : t.innerHeight,
            scrollX: (U = A.scrollX) !== null && U !== void 0 ? U : t.pageXOffset,
            scrollY: (x = A.scrollY) !== null && x !== void 0 ? x : t.pageYOffset
          }, i = new ZA(B.scrollX, B.scrollY, B.windowWidth, B.windowHeight), a = new ou(s, i), c = (p = A.foreignObjectRendering) !== null && p !== void 0 ? p : !1, o = {
            allowTaint: (T = A.allowTaint) !== null && T !== void 0 ? T : !1,
            onclone: A.onclone,
            ignoreElements: A.ignoreElements,
            inlineImages: c,
            copyStyles: c
          }, a.logger.debug("Starting document clone with size " + i.width + "x" + i.height + " scrolled to " + -i.left + "," + -i.top), g = new Fs(a, e, o), f = g.clonedReferenceElement, f ? [4, g.toIFrame(r, i)] : [2, Promise.reject("Unable to find element in cloned iframe")];
        case 1:
          return H = BA.sent(), w = Cn(f) || ul(f) ? NB(f.ownerDocument) : qt(a, f), F = w.width, b = w.height, K = w.left, y = w.top, V = lu(a, f, A.backgroundColor), M = {
            canvas: A.canvas,
            backgroundColor: V,
            scale: (z = (X = A.scale) !== null && X !== void 0 ? X : t.devicePixelRatio) !== null && z !== void 0 ? z : 1,
            x: ((S = A.x) !== null && S !== void 0 ? S : 0) + K,
            y: ((k = A.y) !== null && k !== void 0 ? k : 0) + y,
            width: (G = A.width) !== null && G !== void 0 ? G : Math.ceil(F),
            height: (E = A.height) !== null && E !== void 0 ? E : Math.ceil(b)
          }, c ? (a.logger.debug("Document cloned, using foreign object rendering"), Q = new Bu(a, M), [4, Q.render(f)]) : [3, 3];
        case 2:
          return D = BA.sent(), [3, 5];
        case 3:
          return a.logger.debug("Document cloned, element located at " + K + "," + y + " with size " + F + "x" + b + " using computed rendering"), a.logger.debug("Starting DOM parsing"), d = hB(a, f), V === d.styles.backgroundColor && (d.styles.backgroundColor = YA.TRANSPARENT), a.logger.debug("Starting renderer for element at " + M.x + "," + M.y + " with size " + M.width + "x" + M.height), Q = new Au(a, M), [4, Q.render(d)];
        case 4:
          D = BA.sent(), BA.label = 5;
        case 5:
          return (!((_ = A.removeContainer) !== null && _ !== void 0) || _) && (Fs.destroy(H) || a.logger.error("Cannot detach cloned iframe as it is not in the DOM anymore")), a.logger.debug("Finished rendering"), [2, D];
      }
    });
  });
}, lu = function(e, A, r) {
  var t = A.ownerDocument, n = t.documentElement ? Xe(e, getComputedStyle(t.documentElement).backgroundColor) : YA.TRANSPARENT, s = t.body ? Xe(e, getComputedStyle(t.body).backgroundColor) : YA.TRANSPARENT, B = typeof r == "string" ? Xe(e, r) : r === null ? YA.TRANSPARENT : 4294967295;
  return A === t.documentElement ? ne(n) ? ne(s) ? B : s : n : B;
};
function VA(e) {
  return Math.min(1, Math.max(0, e));
}
function vs(e, A, r) {
  const t = 1 - r;
  return [t * e[0] + r * A[0], t * e[1] + r * A[1], t * e[2] + r * A[2]];
}
function Is(e, A) {
  const r = 0.2126 * e[0] + 0.7152 * e[1] + 0.0722 * e[2];
  return [
    VA(e[0] + (e[0] - r) * A),
    VA(e[1] + (e[1] - r) * A),
    VA(e[2] + (e[2] - r) * A)
  ];
}
function uu(e) {
  const A = e.trim().toLowerCase();
  return A.endsWith("deg") ? parseFloat(A.slice(0, -3)) : A.endsWith("rad") ? parseFloat(A.slice(0, -3)) * 180 / Math.PI : A.endsWith("turn") ? parseFloat(A.slice(0, -4)) * 360 : A.endsWith("grad") ? parseFloat(A.slice(0, -4)) * 360 / 400 : parseFloat(A);
}
function gu(e) {
  const A = e.trim();
  if (!/^oklch\s*\(/i.test(A)) return null;
  const n = A.slice(A.indexOf("(") + 1, A.lastIndexOf(")")).split(/\s*\/\s*/)[0].trim().split(/\s+/).filter(Boolean);
  if (n.length < 3) return null;
  let s;
  n[0].endsWith("%") ? s = Math.min(1, Math.max(0, parseFloat(n[0]) / 100)) : s = Math.min(1, Math.max(0, parseFloat(n[0])));
  let B;
  n[1].endsWith("%") ? B = Math.max(0, parseFloat(n[1]) * 0.4 / 100) : B = Math.max(0, parseFloat(n[1]));
  const i = uu(n[2]);
  return !Number.isFinite(s) || !Number.isFinite(B) || !Number.isFinite(i) ? null : { l: s, c: B, h: i };
}
function fu(e, A, r) {
  const t = Math.pow(e + 0.3963377773761749 * A + 0.2158037573099136 * r, 3), n = Math.pow(e - 0.1055613458156586 * A - 0.0638541728258133 * r, 3), s = Math.pow(e - 0.0894841775298119 * A - 1.2914855480194092 * r, 3);
  return [
    4.076741636075957 * t - 3.3077115392580616 * n + 0.2309699031821044 * s,
    -1.2684379732850317 * t + 2.6097573492876887 * n - 0.3413193760026573 * s,
    -0.0041960761386756 * t - 0.7034186179359362 * n + 1.7076146940746117 * s
  ];
}
function Or(e) {
  const A = Math.abs(e);
  return A > 31308e-7 ? (Math.sign(e) || 1) * (1.055 * Math.pow(A, 1 / 2.4) - 0.055) : e * 12.92;
}
const Rr = "data-ripppl-overlay";
function Gr(e) {
  const A = gu(e);
  if (!A) return [1, 1, 1];
  const r = A.h / 180 * Math.PI, t = A.c ? A.c * Math.cos(r) : 0, n = A.c ? A.c * Math.sin(r) : 0, [s, B, i] = fu(A.l, t, n);
  return [
    VA(Or(s)),
    VA(Or(B)),
    VA(Or(i))
  ];
}
function DB(e) {
  return typeof e == "string" ? Array.from(document.querySelectorAll(e)) : e instanceof HTMLElement ? [e] : Array.from(e);
}
function Qu(e) {
  return e ? typeof e == "string" ? document.querySelector(e) ?? document.body : e : document.body;
}
function cn(e) {
  const r = (getComputedStyle(e).borderRadius || "0").split(/\s+/).filter(Boolean);
  if (r.length === 0) return 0;
  const t = e.getBoundingClientRect();
  let n = 1 / 0;
  for (const s of r)
    if (s.endsWith("%")) {
      const B = parseFloat(s) / 100 * Math.min(t.width, t.height);
      Number.isFinite(B) && (n = Math.min(n, B));
    } else {
      const B = parseFloat(s);
      Number.isFinite(B) && (n = Math.min(n, B));
    }
  return n === 1 / 0 ? 0 : n;
}
function wu(e) {
  const A = getComputedStyle(e), r = A.overflow, t = A.overflowX, n = A.overflowY;
  return r === "hidden" || r === "clip" || t === "hidden" || t === "clip" || n === "hidden" || n === "clip";
}
function ys(e, A) {
  let r = cn(e), t = e.parentElement;
  for (; t && t !== A; )
    wu(t) && (r = Math.max(r, cn(t))), t = t.parentElement;
  return r;
}
function Cu(e, A) {
  if (e === void 0 || e === !1) return [];
  const r = e === !0 ? A : DB(e), t = /* @__PURE__ */ new Set(), n = [];
  for (const s of r)
    t.has(s) || (t.add(s), n.push(s));
  return n;
}
function Ls(e) {
  const A = e.trim().toLowerCase();
  if (A === "transparent") return !0;
  const r = A.match(
    /^rgba\(\s*[\d.]+\s*,\s*[\d.]+\s*,\s*[\d.]+\s*,\s*([\d.]+)\s*\)/
  );
  return r ? parseFloat(r[1]) < 0.5 : !1;
}
function hu(e) {
  let A = e;
  for (; A; ) {
    const t = getComputedStyle(A).backgroundColor;
    if (!Ls(t)) return t;
    A = A.parentElement;
  }
  const r = getComputedStyle(document.body).backgroundColor;
  return Ls(r) ? "#1a1a24" : r;
}
function Uu(e, A, r, t) {
  const n = Math.max(0, Math.min(Math.floor(r), e.naturalWidth - 1)), s = Math.max(0, Math.min(Math.floor(t), e.naturalHeight - 1));
  A.clearRect(0, 0, 1, 1), A.drawImage(e, n, s, 1, 1, 0, 0, 1, 1);
  const B = A.getImageData(0, 0, 1, 1).data;
  if (B[3] > 12) return `rgb(${B[0]}, ${B[1]}, ${B[2]})`;
}
function Tt(e, A, r, t, n, s, B) {
  const i = document.createElement("canvas");
  i.width = 1, i.height = 1;
  const a = i.getContext("2d"), c = [];
  if (B !== void 0 && B > 0.5) {
    const o = Math.min(B, Math.min(t, n) * 0.5 - 1);
    o > 1 && c.push(
      [A + o, r + o],
      [A + t - o, r + o],
      [A + o, r + n - o],
      [A + t - o, r + n - o]
    );
  }
  c.push(
    [A + t * 0.5, r + n - 2],
    [A + t * 0.5, r + 2],
    [A + 1, r + n - 2],
    [A + t - 2, r + n - 2],
    [A + 1, r + 1],
    [A + t - 2, r + 1],
    [A + t * 0.5, r + n * 0.5]
  );
  for (const [o, g] of c) {
    const f = Uu(e, a, o, g);
    if (f) return f;
  }
  return hu(s);
}
const Fu = `attribute vec2 a_pos;
void main(){ gl_Position = vec4(a_pos, 0.0, 1.0); }`, du = `precision highp float;
uniform sampler2D u_tex;
uniform vec2 u_res;
uniform vec2 u_css;
uniform float u_time;
uniform int u_count;
uniform vec3 u_rip[16];
uniform float u_freq, u_speed, u_amp, u_damp, u_decay;
uniform float u_chroma;
uniform vec3 u_shimColor;
uniform float u_shimStr;
uniform float u_shimWidth;
uniform float u_shimIntScale;
uniform float u_shimDur;
uniform vec3 u_glowDodge;
uniform vec3 u_glowScreen;
uniform vec3 u_glowMix;
uniform int u_exclCount;
uniform vec4 u_excl[16];
uniform float u_exclRad[16];
uniform float u_scopeClip;
uniform float u_scopeRad;

float sdRoundBox(vec2 p, vec2 b, float r) {
  vec2 q = abs(p) - b + r;
  return min(max(q.x, q.y), 0.0) + length(max(q, vec2(0.0))) - r;
}

vec3 texRgb(vec2 tuv) {
  vec4 c = texture2D(u_tex, tuv);
  return c.rgb / max(c.a, 0.0001);
}

void main(){
  vec2 uv_frag = gl_FragCoord.xy / u_res;
  vec2 uv = vec2(uv_frag.x, 1.0 - uv_frag.y);
  if (u_scopeClip > 0.5) {
    vec2 sizePx = u_css;
    vec2 pTl = uv * u_css;
    vec2 p = pTl - sizePx * 0.5;
    float r = min(u_scopeRad, min(sizePx.x, sizePx.y) * 0.5);
    float d = sdRoundBox(p, sizePx * 0.5, r);
    if (d > 0.0) {
      gl_FragColor = vec4(texRgb(uv), 1.0);
      return;
    }
  }
  if (u_exclCount > 0) {
    for (int j = 0; j < 16; j++) {
      if (j >= u_exclCount) break;
      vec4 b = u_excl[j];
      if (uv.x < b.x || uv.x > b.x + b.z || uv.y < b.y || uv.y > b.y + b.w) continue;
      vec2 sizePx = b.zw * u_css;
      vec2 pTl = uv * u_css - b.xy * u_css;
      vec2 p = pTl - sizePx * 0.5;
      float r = min(u_exclRad[j], min(sizePx.x, sizePx.y) * 0.5);
      float d = sdRoundBox(p, sizePx * 0.5, r);
      if (d <= 0.0) {
        gl_FragColor = vec4(texRgb(uv), 1.0);
        return;
      }
    }
  }
  vec2 d = vec2(0.0);
  float maxShim = 0.0;
  float maxDodge = 0.0;
  float maxScreen = 0.0;
  float maxOuter = 0.0;
  for(int i = 0; i < 16; i++){
    if(i >= u_count) break;
    vec2 c = u_rip[i].xy;
    float t = u_time - u_rip[i].z;
    vec2 diff = (uv - c) * u_css;
    float dist = length(diff);
    if(dist < 0.5) continue;

    float front = t * u_speed;
    float behind = front - dist;
    float mask = smoothstep(0.0, 2.0, behind);
    float ringDecay = exp(-behind * u_damp);
    float temporal = exp(-t * u_decay);
    float phase = dist * u_freq - t * u_speed * u_freq;
    float wave = sin(phase) * mask * ringDecay * temporal;
    float center = smoothstep(0.0, 10.0, dist);

    d -= normalize(diff) * wave * u_amp * center;

    float b = max(0.0, behind);
    float delayT = clamp((t - 0.05) / 0.32, 0.0, 1.0);
    float delay = (1.0 - pow(1.0 - delayT, 3.0)) * step(0.05, t);
    float growT = clamp(t / 3.9, 0.0, 1.0);
    float easeOut = 1.0 - pow(1.0 - growT, 3.0);
    float radialScale = clamp(1.0 + front * 0.0032 + front * front * 8.0e-7, 1.0, 5.0);
    float sigma = mix(32.0, 142.0, easeOut) * radialScale * u_shimWidth;
    float peak = mix(18.0, 72.0, easeOut) * radialScale * u_shimWidth;
    float x = (b - peak) / max(sigma, 1.0);
    float x2 = x * x;
    float shimBell =
      exp(-x2) * 0.68 + exp(-x2 * 0.52) * 0.32;
    float tailW = mix(0.12, 0.075, easeOut) / (1.0 + t * 1.15 + front * 0.0012);
    float shimTail = exp(-b * tailW);
    float enterW = mix(10.0, 36.0, easeOut) * radialScale * u_shimWidth;
    float shimEnter = smoothstep(0.0, enterW, b);
    float fadeT = clamp(t / max(u_shimDur, 0.001), 0.0, 1.0);
    float opacityEase = 1.0 - pow(fadeT, 2.35);
    float opacityFade = opacityEase * delay * exp(-t * 0.72);
    float shimEdge =
      shimEnter * shimBell * shimTail * opacityFade * center * u_shimIntScale;
    maxShim = max(maxShim, shimEdge);
    float gBase = shimEnter * shimTail * opacityFade * center;
    float su = max(sigma, 1.0);
    float u = (b - peak) / su;
    float ao = (u + 0.78) / 0.48;
    float gOut = exp(-(ao * ao));
    float am = (u + 0.22) / 0.26;
    float gMid = exp(-(am * am));
    float ac = u / 0.1;
    float gHot = exp(-(ac * ac));
    float mOuter =
      max(0.0, gOut - gMid * 0.75 - gHot * 0.15) * gBase * u_shimIntScale;
    float mScreen =
      max(0.0, gMid - gHot * 0.82 - gOut * 0.35) * gBase * u_shimIntScale;
    float mDodge = max(0.0, gHot - gMid * 0.45) * gBase * u_shimIntScale;
    maxDodge = max(maxDodge, mDodge);
    maxScreen = max(maxScreen, mScreen);
    maxOuter = max(maxOuter, mOuter);
  }
  d /= u_css;

  vec3 col;
  if(u_chroma > 0.0){
    vec2 spread = d * u_chroma;
    vec2 perp = vec2(-spread.y, spread.x) * 0.5;

    float r = 0.0, g = 0.0, b = 0.0;
    float tw = 0.0;
    for(int s = -3; s <= 3; s++){
      float f = float(s) / 3.0;
      float w = exp(-2.0 * f * f);
      tw += w;
      vec2 rOff = spread * (f - 1.0) + perp * f;
      vec2 gOff = perp * f * 0.3;
      vec2 bOff = spread * (f + 1.0) - perp * f;
      vec2 st = uv + vec2(d.x, d.y);
      r += texRgb(st + vec2(rOff.x, rOff.y)).r * w;
      g += texRgb(st + vec2(gOff.x, gOff.y)).g * w;
      b += texRgb(st + vec2(bOff.x, bOff.y)).b * w;
    }
    col = vec3(r, g, b) / tw;
  } else {
    col = texRgb(uv + vec2(d.x, d.y));
  }
  if(u_shimStr > 0.0){
    float di = fract(sin(dot(floor(gl_FragCoord.xy), vec2(12.9898, 78.233))) * 43758.5453);
    float n = (di - 0.5) * 0.012;
    float coreAmt = clamp(maxShim * u_shimStr + n, 0.0, 1.0);
    float edge = 1.0 - coreAmt * 0.18;
    float o = clamp(maxOuter * u_shimStr + n, 0.0, 1.0) * edge;
    float s = clamp(maxScreen * u_shimStr + n, 0.0, 1.0) * edge;
    col = mix(col, u_glowMix, o * 0.92);
    vec3 scr = u_glowScreen * s * 1.02;
    scr = min(scr, vec3(0.97));
    col = vec3(1.0) - (vec3(1.0) - col) * (vec3(1.0) - scr);
    col = min(col, vec3(1.0));
    col = mix(col, u_shimColor, coreAmt);
    float dg = clamp(maxDodge * u_shimStr + n, 0.0, 1.0);
    float hot = dg * (0.62 + 0.38 * (1.0 - coreAmt));
    vec3 cs = u_glowDodge * hot * 2.05;
    cs = clamp(cs, vec3(0.0), vec3(0.995));
    vec3 denom = vec3(1.0) - cs;
    denom = max(denom, vec3(0.001));
    col = min(col / denom, vec3(1.0));
  }
  gl_FragColor = vec4(col, 1.0);
}`;
function Eu(e, A = {}) {
  const r = DB(e), t = Qu(A.scope), n = t === document.body, s = Cu(A.exclude, r), B = s.length > 0 ? 2147483646 : 2147483647, i = () => {
    if (n)
      return { left: 0, top: 0, width: innerWidth, height: innerHeight };
    const h = t.getBoundingClientRect(), P = getComputedStyle(t), Y = parseFloat(P.borderLeftWidth) || 0, iA = parseFloat(P.borderTopWidth) || 0;
    return {
      left: h.left + Y,
      top: h.top + iA,
      width: t.clientWidth,
      height: t.clientHeight
    };
  };
  let a = A.amplitude ?? 3, c = A.frequency ?? 0.018, o = A.speed ?? 300, g = A.damping ?? 0.025, f = A.decay ?? 1.2, H = (A.duration ?? 3500) / 1e3, w = A.chromatic ?? !1, F = A.chromaticIntensity ?? 0.4, b = A.shimmer ? Gr(A.shimmer) : [1, 1, 1], K = A.shimmer ? 1 : 0, y = A.shimmerWidth ?? 1, V = (A.shimmerDuration ?? 2600) / 1e3, M = A.shimmerGlowColor;
  const D = () => {
    if (!K)
      return {
        dodge: [1, 1, 1],
        screen: [1, 1, 1],
        mix: [1, 1, 1]
      };
    const h = M ? Gr(M) : b;
    return {
      dodge: vs(h, [1, 1, 1], 0.94),
      screen: Is(h, 1.72),
      mix: vs(Is(h, 0.45), [1, 1, 1], 0.4)
    };
  };
  let d = D();
  const Q = document.createElement("canvas");
  if (Q.setAttribute(Rr, ""), n)
    Q.style.cssText = `position:fixed;top:0;left:0;width:100%;height:100%;pointer-events:none;z-index:${B};`;
  else {
    getComputedStyle(t).position === "static" && (t.style.position = "relative");
    const P = getComputedStyle(t);
    Q.style.cssText = `position:absolute;top:0;left:0;width:100%;height:100%;pointer-events:none;z-index:${B};`, Q.style.borderRadius = P.borderRadius, Q.style.overflow = "hidden";
  }
  n ? document.body.appendChild(Q) : t.appendChild(Q);
  const l = Q.getContext("webgl", {
    premultipliedAlpha: !1,
    alpha: !0,
    antialias: !0
  });
  if (!l)
    return Q.remove(), {
      destroy() {
      },
      update() {
      },
      invalidateCapture() {
      },
      prefetchCapture() {
      },
      trigger() {
      }
    };
  const C = (h, P) => {
    const Y = l.createShader(h);
    return l.shaderSource(Y, P), l.compileShader(Y), Y;
  }, m = l.createProgram();
  l.attachShader(m, C(l.VERTEX_SHADER, Fu)), l.attachShader(m, C(l.FRAGMENT_SHADER, du)), l.linkProgram(m), l.useProgram(m), l.enable(l.BLEND), l.blendFunc(l.SRC_ALPHA, l.ONE_MINUS_SRC_ALPHA);
  const R = l.createBuffer();
  l.bindBuffer(l.ARRAY_BUFFER, R), l.bufferData(
    l.ARRAY_BUFFER,
    new Float32Array([-1, -1, 1, -1, -1, 1, 1, 1]),
    l.STATIC_DRAW
  );
  const I = l.getAttribLocation(m, "a_pos");
  l.enableVertexAttribArray(I), l.vertexAttribPointer(I, 2, l.FLOAT, !1, 0, 0);
  const u = (h) => l.getUniformLocation(m, h), U = u("u_res"), x = u("u_css"), p = u("u_time"), T = u("u_count"), X = u("u_freq"), z = u("u_speed"), S = u("u_amp"), k = u("u_damp"), G = u("u_decay"), E = u("u_chroma"), _ = u("u_shimColor"), BA = u("u_shimStr"), uA = u("u_shimWidth"), wA = u("u_shimIntScale"), OA = u("u_shimDur"), gA = u("u_glowDodge"), CA = u("u_glowScreen"), xA = u("u_glowMix"), j = u("u_exclCount"), J = [];
  for (let h = 0; h < 16; h++) J.push(u(`u_excl[${h}]`));
  const HA = [];
  for (let h = 0; h < 16; h++) HA.push(u(`u_exclRad[${h}]`));
  const RA = u("u_scopeClip"), ge = u("u_scopeRad"), $e = [];
  for (let h = 0; h < 16; h++) $e.push(u(`u_rip[${h}]`));
  const At = l.createTexture();
  l.bindTexture(l.TEXTURE_2D, At), l.texParameteri(l.TEXTURE_2D, l.TEXTURE_WRAP_S, l.CLAMP_TO_EDGE), l.texParameteri(l.TEXTURE_2D, l.TEXTURE_WRAP_T, l.CLAMP_TO_EDGE), l.texParameteri(l.TEXTURE_2D, l.TEXTURE_MIN_FILTER, l.LINEAR), l.texParameteri(l.TEXTURE_2D, l.TEXTURE_MAG_FILTER, l.LINEAR);
  const hA = [];
  let PA = 0, Be = !1, bA = !1, XA = null, FA = !1;
  const et = () => {
    bA = !1;
  }, fe = () => et();
  window.addEventListener("resize", fe), window.addEventListener("scroll", fe, { capture: !0, passive: !0 });
  const Br = () => {
    const h = devicePixelRatio || 1, P = n ? innerWidth : t.clientWidth, Y = n ? innerHeight : t.clientHeight, iA = Math.round(P * h), eA = Math.round(Y * h);
    (Q.width !== iA || Q.height !== eA) && (Q.width = iA, Q.height = eA, l.viewport(0, 0, iA, eA));
  };
  Br();
  const hn = () => {
    l.clearColor(0, 0, 0, 0), l.clear(l.COLOR_BUFFER_BIT);
  }, tt = async () => {
    if (!FA && !(bA && !XA) && !(XA && (await XA, bA || FA))) {
      XA = (async () => {
        hn();
        try {
          const h = devicePixelRatio || 1, P = innerWidth, Y = innerHeight, iA = (O) => {
            l.bindTexture(l.TEXTURE_2D, At), l.pixelStorei(l.UNPACK_PREMULTIPLY_ALPHA_WEBGL, !1), l.texImage2D(
              l.TEXTURE_2D,
              0,
              l.RGBA,
              l.RGBA,
              l.UNSIGNED_BYTE,
              O
            ), bA = !0, Br();
          }, eA = Math.round(P * h), qA = Math.round(Y * h), tA = window.scrollX, Qe = window.scrollY;
          let ie = null;
          if (!n) {
            const O = t.getBoundingClientRect(), AA = getComputedStyle(t), vA = parseFloat(AA.borderLeftWidth) || 0, Ce = parseFloat(AA.borderTopWidth) || 0;
            ie = {
              left: O.left + vA,
              top: O.top + Ce,
              width: t.clientWidth,
              height: t.clientHeight
            };
          }
          const ar = (O) => !(O instanceof Element && O.hasAttribute(Rr)), nt = (O) => O.hasAttribute(Rr);
          let we = !1, mA;
          if (!n)
            try {
              const O = await ms(t, {
                scale: h,
                backgroundColor: null,
                logging: !1,
                useCORS: !0,
                ignoreElements: (AA) => AA instanceof Element && nt(AA)
              });
              if (O.width >= 1 && O.height >= 1)
                try {
                  mA = O.toDataURL("image/png"), we = !0;
                } catch {
                  mA = void 0;
                }
            } catch {
              mA = void 0;
            }
          if (!mA) {
            we = !1;
            try {
              const O = await ms(document.documentElement, {
                scale: h,
                scrollX: tA,
                scrollY: Qe,
                windowWidth: P,
                windowHeight: Y,
                x: tA,
                y: Qe,
                width: P,
                height: Y,
                backgroundColor: null,
                logging: !1,
                useCORS: !0,
                ignoreElements: (AA) => AA instanceof Element && nt(AA)
              });
              if (O.width >= 1 && O.height >= 1)
                try {
                  mA = O.toDataURL("image/png");
                } catch {
                  mA = void 0;
                }
            } catch {
              mA = void 0;
            }
          }
          if (!mA)
            try {
              mA = await VB.toPng(document.documentElement, {
                width: P,
                height: Y,
                scale: h,
                style: {
                  transform: `translate(${-tA}px, ${-Qe}px)`,
                  transformOrigin: "top left",
                  width: P + "px",
                  height: Y + "px"
                },
                filter: ar
              }), we = !1;
            } catch {
              return;
            }
          if (FA) return;
          const dA = new Image();
          if (dA.src = mA, await dA.decode(), FA) return;
          const DA = dA.naturalWidth, TA = dA.naturalHeight;
          if (DA < 1 || TA < 1) return;
          if (n) {
            const O = document.createElement("canvas");
            O.width = eA, O.height = qA;
            const AA = O.getContext("2d");
            AA.fillStyle = Tt(dA, 0, 0, DA, TA, document.body), AA.fillRect(0, 0, eA, qA), AA.drawImage(dA, 0, 0, DA, TA, 0, 0, eA, qA), iA(O);
          } else {
            const O = ie;
            if (O.width < 1 || O.height < 1) return;
            const AA = Math.round(O.width * h), vA = Math.round(O.height * h), Ce = document.createElement("canvas");
            Ce.width = AA, Ce.height = vA;
            const kA = Ce.getContext("2d");
            let st = 0;
            for (const Bt of s)
              st = Math.max(
                st,
                ys(Bt, t)
              );
            const or = st > 0 ? st : void 0;
            if (we)
              kA.fillStyle = Tt(
                dA,
                0,
                0,
                DA,
                TA,
                t,
                or
              ), kA.fillRect(0, 0, AA, vA), kA.drawImage(dA, 0, 0, DA, TA, 0, 0, AA, vA);
            else {
              const Bt = O.left / P * DA, pn = O.top / Y * TA, En = O.width / P * DA, Hn = O.height / Y * TA;
              if (O.left >= -0.5 && O.top >= -0.5 && O.left + O.width <= P + 0.5 && O.top + O.height <= Y + 0.5)
                kA.fillStyle = Tt(
                  dA,
                  Bt,
                  pn,
                  En,
                  Hn,
                  t,
                  or
                ), kA.fillRect(0, 0, AA, vA), kA.drawImage(dA, Bt, pn, En, Hn, 0, 0, AA, vA);
              else {
                const cr = Math.min(P, Math.max(0, O.left)), lr = Math.min(Y, Math.max(0, O.top)), TB = Math.min(P, Math.max(0, O.left + O.width)), SB = Math.min(Y, Math.max(0, O.top + O.height)), ur = TB - cr, gr = SB - lr;
                if (ur < 1 || gr < 1) return;
                let Ke = Math.round(cr / P * DA), xe = Math.round(lr / Y * TA), it = Math.round(ur / P * DA), at = Math.round(gr / Y * TA);
                Ke = Math.min(Math.max(0, Ke), DA - 1), xe = Math.min(Math.max(0, xe), TA - 1), it = Math.min(Math.max(1, it), DA - Ke), at = Math.min(Math.max(1, at), TA - xe);
                let ot = Math.round((cr - O.left) / O.width * AA), ct = Math.round((lr - O.top) / O.height * vA), fr = Math.round(ur / O.width * AA), Qr = Math.round(gr / O.height * vA);
                ot = Math.max(0, Math.min(ot, AA - 1)), ct = Math.max(0, Math.min(ct, vA - 1)), fr = Math.max(1, Math.min(fr, AA - ot)), Qr = Math.max(1, Math.min(Qr, vA - ct)), kA.fillStyle = Tt(
                  dA,
                  Ke,
                  xe,
                  it,
                  at,
                  t,
                  or
                ), kA.fillRect(0, 0, AA, vA), kA.drawImage(dA, Ke, xe, it, at, ot, ct, fr, Qr);
              }
            }
            iA(Ce);
          }
        } catch {
        } finally {
        }
        bA && hA.length > 0 && !Be && (Be = !0, cancelAnimationFrame(PA), PA = requestAnimationFrame(rt));
      })();
      try {
        await XA;
      } finally {
        XA = null;
      }
    }
  }, rt = () => {
    const h = performance.now() / 1e3;
    let P = 0;
    for (; P < hA.length; )
      h - hA[P].t0 > H ? hA.splice(P, 1) : P++;
    if (hA.length === 0) {
      hn(), Be = !1;
      return;
    }
    if (!bA) {
      PA = requestAnimationFrame(rt);
      return;
    }
    Br(), l.clearColor(0, 0, 0, 0), l.clear(l.COLOR_BUFFER_BIT);
    const Y = n ? innerWidth : t.clientWidth, iA = n ? innerHeight : t.clientHeight;
    l.uniform2f(U, Q.width, Q.height), l.uniform2f(x, Y, iA), l.uniform1f(p, h), l.uniform1i(T, hA.length), l.uniform1f(X, c), l.uniform1f(z, o), l.uniform1f(S, a), l.uniform1f(k, g), l.uniform1f(G, f), l.uniform1f(E, w ? F : 0), l.uniform3f(_, b[0], b[1], b[2]), l.uniform1f(BA, K), l.uniform1f(uA, y), l.uniform1f(
      wA,
      1 / Math.sqrt(Math.max(0.2, y))
    ), l.uniform1f(OA, V), RA && ge && (n ? (l.uniform1f(RA, 0), l.uniform1f(ge, 0)) : (l.uniform1f(RA, 1), l.uniform1f(ge, cn(t)))), l.uniform3f(
      gA,
      d.dodge[0],
      d.dodge[1],
      d.dodge[2]
    ), l.uniform3f(
      CA,
      d.screen[0],
      d.screen[1],
      d.screen[2]
    ), l.uniform3f(
      xA,
      d.mix[0],
      d.mix[1],
      d.mix[2]
    );
    for (let tA = 0; tA < Math.min(hA.length, 16); tA++)
      l.uniform3f($e[tA], hA[tA].cx, hA[tA].cy, hA[tA].t0);
    const eA = i(), qA = Math.min(s.length, 16);
    l.uniform1i(j, qA);
    for (let tA = 0; tA < 16; tA++)
      if (tA < qA) {
        const Qe = s[tA], ie = Qe.getBoundingClientRect(), ar = (ie.left - eA.left) / eA.width, nt = (ie.top - eA.top) / eA.height, we = ie.width / eA.width, mA = ie.height / eA.height;
        l.uniform4f(J[tA], ar, nt, we, mA);
        const dA = ys(Qe, t);
        l.uniform1f(HA[tA], dA);
      } else
        l.uniform4f(J[tA], 0, 0, 0, 0), l.uniform1f(HA[tA], 0);
    l.drawArrays(l.TRIANGLE_STRIP, 0, 4), PA = requestAnimationFrame(rt);
  }, ir = async (h, P) => {
    if (FA) return;
    const Y = VA(h), iA = VA(P);
    bA || await tt();
    const eA = performance.now() / 1e3;
    hA.push({ cx: Y, cy: iA, t0: eA }), hA.length > 16 && hA.shift(), bA && !Be && (Be = !0, cancelAnimationFrame(PA), PA = requestAnimationFrame(rt));
  }, Un = async (h) => {
    if (!(h instanceof MouseEvent) || h.button !== 0) return;
    const P = i(), Y = (h.clientX - P.left) / P.width, iA = (h.clientY - P.top) / P.height;
    await ir(Y, iA);
  }, Fn = () => {
    !FA && !bA && tt();
  };
  r.forEach((h) => {
    h.addEventListener("click", Un, !0), h.addEventListener("pointerdown", Fn, { passive: !0 });
  });
  const dn = () => {
    !FA && !bA && !XA && tt();
  };
  return typeof requestIdleCallback == "function" ? requestIdleCallback(dn, { timeout: 1200 }) : setTimeout(dn, 300), {
    destroy() {
      FA = !0, cancelAnimationFrame(PA), window.removeEventListener("resize", fe), window.removeEventListener("scroll", fe, { capture: !0 }), r.forEach((h) => {
        h.removeEventListener("click", Un, !0), h.removeEventListener("pointerdown", Fn);
      }), Q.remove();
    },
    invalidateCapture() {
      FA || et();
    },
    prefetchCapture() {
      FA || tt();
    },
    trigger(h) {
      if (h != null && h.fromElement) {
        const iA = i(), eA = h.fromElement.getBoundingClientRect(), qA = (eA.left + eA.width * 0.5 - iA.left) / iA.width, tA = (eA.top + eA.height * 0.5 - iA.top) / iA.height;
        ir(VA(qA), VA(tA));
        return;
      }
      const P = (h == null ? void 0 : h.x) ?? 0.5, Y = (h == null ? void 0 : h.y) ?? 0.5;
      ir(P, Y);
    },
    update(h) {
      h.amplitude !== void 0 && (a = h.amplitude), h.frequency !== void 0 && (c = h.frequency), h.speed !== void 0 && (o = h.speed), h.damping !== void 0 && (g = h.damping), h.decay !== void 0 && (f = h.decay), h.duration !== void 0 && (H = h.duration / 1e3), h.chromatic !== void 0 && (w = h.chromatic), h.chromaticIntensity !== void 0 && (F = h.chromaticIntensity), h.shimmer !== void 0 && (h.shimmer ? (b = Gr(h.shimmer), K = 1) : K = 0), h.shimmerWidth !== void 0 && (y = h.shimmerWidth), h.shimmerDuration !== void 0 && (V = h.shimmerDuration / 1e3), h.shimmerGlowColor !== void 0 && (M = h.shimmerGlowColor), (h.shimmer !== void 0 || h.shimmerGlowColor !== void 0) && (d = D());
    }
  };
}
window.Ripppl = { RIPPPL_CAPTURE_IGNORE_ATTR: Rr, attachRipple: Eu };
