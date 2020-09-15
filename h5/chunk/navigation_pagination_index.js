(window.webpackJsonp=window.webpackJsonp||[]).push([[40],{"103":function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{"value":!0}),t.default=void 0;var a=function(){function defineProperties(e,t){for(var n=0;n<t.length;n++){var a=t[n];a.enumerable=a.enumerable||!1,a.configurable=!0,"value"in a&&(a.writable=!0),Object.defineProperty(e,a.key,a)}}return function(e,t,n){return t&&defineProperties(e.prototype,t),n&&defineProperties(e,n),e}}(),o=function get(e,t,n){null===e&&(e=Function.prototype);var a=Object.getOwnPropertyDescriptor(e,t);if(void 0===a){var o=Object.getPrototypeOf(e);return null===o?void 0:get(o,t,n)}if("value"in a)return a.value;var i=a.get;return void 0!==i?i.call(n):void 0},i=_interopRequireDefault(n(1)),r=n(138),l=n(131),c=_interopRequireDefault(n(4)),u=_interopRequireDefault(n(133));function _interopRequireDefault(e){return e&&e.__esModule?e:{"default":e}}n(495);var s=function(e){function PaginationPage(){!function _classCallCheck(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,PaginationPage);var e=function _possibleConstructorReturn(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(PaginationPage.__proto__||Object.getPrototypeOf(PaginationPage)).apply(this,arguments));return e.config={"navigationBarTitleText":"Taro UI"},e.state={"list":[],"current":1,"pageSize":10},e}return function _inherits(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{"constructor":{"value":e,"enumerable":!1,"writable":!0,"configurable":!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(PaginationPage,c.default.Component),a(PaginationPage,[{"key":"onPage","value":function onPage(e){console.log("pagination: ",e),this.setState({"current":e.current})}},{"key":"onPageDataChange","value":function onPageDataChange(){var e=new Array(10).fill(1);this.setState({"list":this.state.list.concat(e)})}},{"key":"onCurrentChange","value":function onCurrentChange(){this.setState({"current":1,"list":[]})}},{"key":"render","value":function render(){var e=this.state.list.length;return i.default.createElement(l.View,{"className":"page"},i.default.createElement(u.default,{"title":"Pagination 分页器"}),i.default.createElement(l.View,{"className":"doc-body"},i.default.createElement(l.View,{"className":"panel"},i.default.createElement(l.View,{"className":"panel__title"},"基础用法"),i.default.createElement(l.View,{"className":"panel__content no-padding"},i.default.createElement(l.View,{"className":"example-item"},i.default.createElement(r.AtPagination,{"total":20,"pageSize":10,"current":1})))),i.default.createElement(l.View,{"className":"panel"},i.default.createElement(l.View,{"className":"panel__title"},"图标类型"),i.default.createElement(l.View,{"className":"panel__content no-padding"},i.default.createElement(l.View,{"className":"example-item"},i.default.createElement(r.AtPagination,{"icon":!0,"total":20,"pageSize":10,"current":1})))),i.default.createElement(l.View,{"className":"panel"},i.default.createElement(l.View,{"className":"panel__title"},"picker快速选择页码"),i.default.createElement(l.View,{"className":"panel__content no-padding"},i.default.createElement(l.View,{"className":"example-item"},i.default.createElement(r.AtPagination,{"icon":!0,"total":20,"pageSize":10,"current":1})))),i.default.createElement(l.View,{"className":"panel"},i.default.createElement(l.View,{"className":"panel__title"},"改变数据长度"),i.default.createElement(l.View,{"className":"panel__content no-padding"},i.default.createElement(l.View,{"className":"example-item"},i.default.createElement(r.AtPagination,{"icon":!0,"total":e,"pageSize":this.state.pageSize,"current":this.state.current,"onPageChange":this.onPage.bind(this)}),i.default.createElement(l.View,{"className":"btn-item"},"当前页：",this.state.current,"，当前数据：",e,"条，分页大小：",this.state.pageSize),i.default.createElement(l.View,{"className":"btn-item"},i.default.createElement(r.AtButton,{"type":"primary","onClick":this.onPageDataChange.bind(this)},"增加10条数据")),i.default.createElement(l.View,{"className":"btn-item"},i.default.createElement(r.AtButton,{"onClick":this.onCurrentChange.bind(this)},"重置")))))))}},{"key":"componentDidMount","value":function componentDidMount(){o(PaginationPage.prototype.__proto__||Object.getPrototypeOf(PaginationPage.prototype),"componentDidMount",this)&&o(PaginationPage.prototype.__proto__||Object.getPrototypeOf(PaginationPage.prototype),"componentDidMount",this).call(this)}},{"key":"componentDidShow","value":function componentDidShow(){o(PaginationPage.prototype.__proto__||Object.getPrototypeOf(PaginationPage.prototype),"componentDidShow",this)&&o(PaginationPage.prototype.__proto__||Object.getPrototypeOf(PaginationPage.prototype),"componentDidShow",this).call(this)}},{"key":"componentDidHide","value":function componentDidHide(){o(PaginationPage.prototype.__proto__||Object.getPrototypeOf(PaginationPage.prototype),"componentDidHide",this)&&o(PaginationPage.prototype.__proto__||Object.getPrototypeOf(PaginationPage.prototype),"componentDidHide",this).call(this)}}]),PaginationPage}();t.default=s},"133":function(e,t,n){"use strict";Object.defineProperty(t,"__esModule",{"value":!0}),t.default=void 0;var a=function(){function defineProperties(e,t){for(var n=0;n<t.length;n++){var a=t[n];a.enumerable=a.enumerable||!1,a.configurable=!0,"value"in a&&(a.writable=!0),Object.defineProperty(e,a.key,a)}}return function(e,t,n){return t&&defineProperties(e.prototype,t),n&&defineProperties(e,n),e}}(),o=_interopRequireDefault(n(1)),i=_interopRequireDefault(n(4)),r=_interopRequireDefault(n(132)),l=n(131);function _interopRequireDefault(e){return e&&e.__esModule?e:{"default":e}}n(134);var c=function(e){function DocsHeader(){return function _classCallCheck(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,DocsHeader),function _possibleConstructorReturn(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(DocsHeader.__proto__||Object.getPrototypeOf(DocsHeader)).apply(this,arguments))}return function _inherits(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{"constructor":{"value":e,"enumerable":!1,"writable":!0,"configurable":!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(DocsHeader,i.default.Component),a(DocsHeader,[{"key":"render","value":function render(){var e=this.props.title;return o.default.createElement(l.View,{"className":"doc-header"},o.default.createElement(l.View,{"className":"doc-header__title"},e))}}]),DocsHeader}();t.default=c,c.defaultProps={"title":"标题"},c.propTypes={"title":r.default.string}},"134":function(e,t,n){},"495":function(e,t,n){}}]);