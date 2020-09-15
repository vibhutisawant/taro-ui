(window.webpackJsonp=window.webpackJsonp||[]).push([[14],{"133":function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{"value":!0}),t.default=void 0;var n=function(){function defineProperties(e,t){for(var a=0;a<t.length;a++){var n=t[a];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(e,t,a){return t&&defineProperties(e.prototype,t),a&&defineProperties(e,a),e}}(),o=_interopRequireDefault(a(1)),l=_interopRequireDefault(a(4)),i=_interopRequireDefault(a(132)),c=a(131);function _interopRequireDefault(e){return e&&e.__esModule?e:{"default":e}}a(134);var r=function(e){function DocsHeader(){return function _classCallCheck(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,DocsHeader),function _possibleConstructorReturn(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(DocsHeader.__proto__||Object.getPrototypeOf(DocsHeader)).apply(this,arguments))}return function _inherits(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{"constructor":{"value":e,"enumerable":!1,"writable":!0,"configurable":!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(DocsHeader,l.default.Component),n(DocsHeader,[{"key":"render","value":function render(){var e=this.props.title;return o.default.createElement(c.View,{"className":"doc-header"},o.default.createElement(c.View,{"className":"doc-header__title"},e))}}]),DocsHeader}();t.default=r,r.defaultProps={"title":"标题"},r.propTypes={"title":i.default.string}},"134":function(e,t,a){},"443":function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{"value":!0}),t.default={"main":["analytics","bell","blocked","bookmark","bullet-list","calendar","add-circle","subtract-circle","check-circle","close-circle","add","subtract","check","close","clock","credit-card","download-cloud","download","equalizer","external-link","eye","filter","folder","heart","heart-2","star","star-2","help","alert-circle","home","iphone-x","iphone","lightning-bolt","link","list","lock","mail","map-pin","menu","message","money","numbered-list","phone","search","settings","share-2","share","shopping-bag-2","shopping-bag","shopping-cart","streaming","tag","tags","trash","upload","user","loading","loading-2","loading-3"],"file":["file-audio","file-code","file-generic","file-jpg","file-new","file-png","file-svg","file-video"],"text":["align-center","align-left","align-right","edit","font-color","text-italic","text-strikethrough","text-underline"],"arrow":["arrow-up","arrow-down","arrow-left","arrow-right","chevron-up","chevron-down","chevron-left","chevron-right"],"media":["play","pause","stop","prev","next","reload","repeat-play","shuffle-play","playlist","sound","volume-off","volume-minus","volume-plus"],"photo":["camera","image","video"],"logo":["sketch"]}},"444":function(e,t,a){},"79":function(e,t,a){"use strict";Object.defineProperty(t,"__esModule",{"value":!0}),t.default=void 0;var n=function(){function defineProperties(e,t){for(var a=0;a<t.length;a++){var n=t[a];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(e,n.key,n)}}return function(e,t,a){return t&&defineProperties(e.prototype,t),a&&defineProperties(e,a),e}}(),o=function get(e,t,a){null===e&&(e=Function.prototype);var n=Object.getOwnPropertyDescriptor(e,t);if(void 0===n){var o=Object.getPrototypeOf(e);return null===o?void 0:get(o,t,a)}if("value"in n)return n.value;var l=n.get;return void 0!==l?l.call(a):void 0},l=_interopRequireDefault(a(1)),i=_interopRequireDefault(a(4)),c=a(131),r=a(138),s=_interopRequireDefault(a(133)),u=_interopRequireDefault(a(443));function _interopRequireDefault(e){return e&&e.__esModule?e:{"default":e}}a(444);var f=function(e){function IconPage(){!function _classCallCheck(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,IconPage);var e=function _possibleConstructorReturn(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(IconPage.__proto__||Object.getPrototypeOf(IconPage)).call(this));return e.config={"navigationBarTitleText":"Taro UI"},e.state={"icons":u.default},e}return function _inherits(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{"constructor":{"value":e,"enumerable":!1,"writable":!0,"configurable":!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(IconPage,i.default.Component),n(IconPage,[{"key":"render","value":function render(){var e=this.state.icons;return l.default.createElement(c.View,{"className":"page"},l.default.createElement(s.default,{"title":"ICON 图标"}),l.default.createElement(c.View,{"className":"doc-body"},l.default.createElement(c.View,{"className":"panel"},l.default.createElement(c.View,{"className":"panel__title"},"主要"),l.default.createElement(c.View,{"className":"panel__content"},l.default.createElement(c.View,{"className":"icon-list"},e.main.map(function(e,t){return l.default.createElement(c.View,{"className":"icon-list__item","key":"at-icon-"+t},l.default.createElement(c.View,{"className":"icon-list__icon"},l.default.createElement(r.AtIcon,{"value":e,"color":"#999","size":30})),l.default.createElement(c.View,{"className":"icon-list__name"},e))})))),l.default.createElement(c.View,{"className":"panel"},l.default.createElement(c.View,{"className":"panel__title"},"文件"),l.default.createElement(c.View,{"className":"panel__content"},l.default.createElement(c.View,{"className":"icon-list"},e.file.map(function(e,t){return l.default.createElement(c.View,{"className":"icon-list__item","key":"at-icon-"+t},l.default.createElement(c.View,{"className":"icon-list__icon"},l.default.createElement(r.AtIcon,{"value":e,"color":"#999","size":30})),l.default.createElement(c.View,{"className":"icon-list__name"},e))})))),l.default.createElement(c.View,{"className":"panel"},l.default.createElement(c.View,{"className":"panel__title"},"文本"),l.default.createElement(c.View,{"className":"panel__content"},l.default.createElement(c.View,{"className":"icon-list"},e.text.map(function(e,t){return l.default.createElement(c.View,{"className":"icon-list__item","key":"at-icon-"+t},l.default.createElement(c.View,{"className":"icon-list__icon"},l.default.createElement(r.AtIcon,{"value":e,"color":"#999","size":30})),l.default.createElement(c.View,{"className":"icon-list__name"},e))})))),l.default.createElement(c.View,{"className":"panel"},l.default.createElement(c.View,{"className":"panel__title"},"箭头"),l.default.createElement(c.View,{"className":"panel__content"},l.default.createElement(c.View,{"className":"icon-list"},e.arrow.map(function(e,t){return l.default.createElement(c.View,{"className":"icon-list__item","key":"at-icon-"+t},l.default.createElement(c.View,{"className":"icon-list__icon"},l.default.createElement(r.AtIcon,{"value":e,"color":"#999","size":30})),l.default.createElement(c.View,{"className":"icon-list__name"},e))})))),l.default.createElement(c.View,{"className":"panel"},l.default.createElement(c.View,{"className":"panel__title"},"媒体控制"),l.default.createElement(c.View,{"className":"panel__content"},l.default.createElement(c.View,{"className":"icon-list"},e.media.map(function(e,t){return l.default.createElement(c.View,{"className":"icon-list__item","key":"at-icon-"+t},l.default.createElement(c.View,{"className":"icon-list__icon"},l.default.createElement(r.AtIcon,{"value":e,"color":"#999","size":30})),l.default.createElement(c.View,{"className":"icon-list__name"},e))})))),l.default.createElement(c.View,{"className":"panel"},l.default.createElement(c.View,{"className":"panel__title"},"多媒体"),l.default.createElement(c.View,{"className":"panel__content"},l.default.createElement(c.View,{"className":"icon-list"},e.photo.map(function(e,t){return l.default.createElement(c.View,{"className":"icon-list__item","key":"at-icon-"+t},l.default.createElement(c.View,{"className":"icon-list__icon"},l.default.createElement(r.AtIcon,{"value":e,"color":"#999","size":30})),l.default.createElement(c.View,{"className":"icon-list__name"},e))})))),l.default.createElement(c.View,{"className":"panel"},l.default.createElement(c.View,{"className":"panel__title"},"Logo"),l.default.createElement(c.View,{"className":"panel__content"},l.default.createElement(c.View,{"className":"icon-list"},e.logo.map(function(e,t){return l.default.createElement(c.View,{"className":"icon-list__item","key":"at-icon-"+t},l.default.createElement(c.View,{"className":"icon-list__icon"},l.default.createElement(r.AtIcon,{"value":e,"color":"#999","size":30})),l.default.createElement(c.View,{"className":"icon-list__name"},e))}))))))}},{"key":"componentDidMount","value":function componentDidMount(){o(IconPage.prototype.__proto__||Object.getPrototypeOf(IconPage.prototype),"componentDidMount",this)&&o(IconPage.prototype.__proto__||Object.getPrototypeOf(IconPage.prototype),"componentDidMount",this).call(this)}},{"key":"componentDidShow","value":function componentDidShow(){o(IconPage.prototype.__proto__||Object.getPrototypeOf(IconPage.prototype),"componentDidShow",this)&&o(IconPage.prototype.__proto__||Object.getPrototypeOf(IconPage.prototype),"componentDidShow",this).call(this)}},{"key":"componentDidHide","value":function componentDidHide(){o(IconPage.prototype.__proto__||Object.getPrototypeOf(IconPage.prototype),"componentDidHide",this)&&o(IconPage.prototype.__proto__||Object.getPrototypeOf(IconPage.prototype),"componentDidHide",this).call(this)}}]),IconPage}();t.default=f}}]);