---
layout: post
category: swing
folder: HyperlinkHoverEffect
title: JEditorPaneに表示したリンク上にカーソルが乗ったとき文字色を変更する
tags: [JEditorPane, HTML, HyperlinkListener]
author: aterai
pubdate: 2015-11-23T04:24:22+09:00
description: JEditorPaneに表示したリンクで:hover擬似クラスのような効果を行うためのHyperlinkListenerを設定します。
comments: true
---
## 概要
`JEditorPane`に表示したリンクで`:hover`擬似クラスのような効果を行うための`HyperlinkListener`を設定します。

{% download https://lh3.googleusercontent.com/-8YH7U9Pzs_c/VlITNjFkBKI/AAAAAAAAOHM/9wWxL-OhdoE/s800-Ic42/HyperlinkHoverEffect.png %}

## サンプルコード
<pre class="prettyprint"><code>editor.setEditable(false);
//@see: BasicEditorPaneUI#propertyChange(PropertyChangeEvent evt) {
//      if ("foreground".equals(name)) {
editor.putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);
editor.addHyperlinkListener(new HyperlinkListener() {
  @Override public void hyperlinkUpdate(HyperlinkEvent e) {
    if (e.getEventType() == HyperlinkEvent.EventType.ENTERED) {
      setElementColor(e.getSourceElement(), "red");
    } else if (e.getEventType() == HyperlinkEvent.EventType.EXITED) {
      setElementColor(e.getSourceElement(), "blue");
    } else if (e.getEventType() == HyperlinkEvent.EventType.ACTIVATED) {
      Toolkit.getDefaultToolkit().beep();
    }
    //??? call BasicTextUI#modelChanged() ???
    editor.setForeground(Color.WHITE);
    editor.setForeground(Color.BLACK);
  }
});
</code></pre>

## 解説
- [JLabelで表示するHtmlアンカータグの文字色を変更する](http://ateraimemo.com/Swing/AnchorTextColor.html)で、`StyleSheet`に`addRule("a:hover{color:#FF0000;}")`としても効果がない
- `HyperlinkListener`を`JEditorPane`に設定し、`HyperlinkEvent.EventType.ENTERED`イベントでリンク文字色を赤に変更、`HyperlinkEvent.EventType.EXITED`イベントで青に戻すよう設定
- リンク文字色の変更は`HyperlinkEvent`から取得した`Element`の属性に、以下のように`addAttribute(HTML.Attribute.COLOR, color)`メソッドを使用して設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>private void setElementColor(Element element, String color) {
  AttributeSet attrs = element.getAttributes();
  Object o = attrs.getAttribute(HTML.Tag.A);
  if (o instanceof MutableAttributeSet) {
    MutableAttributeSet a = (MutableAttributeSet) o;
    a.addAttribute(HTML.Attribute.COLOR, color);
  }
}
</code></pre>

## 参考リンク
- [JLabelで表示するHtmlアンカータグの文字色を変更する](http://ateraimemo.com/Swing/AnchorTextColor.html)

<!-- dummy comment line for breaking list -->

## コメント