---
layout: post
title: JEditorPaneで長い行を折り返さない
category: swing
folder: NoWrapTextPane
tags: [JEditorPane, JTextPane, StyledDocument]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2007-09-24

## JEditorPaneで長い行を折り返さない
`JEditorPane`や、`JTextPane`で、行を`Viewport`の幅で折り返さないよう設定します。
- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh6.ggpht.com/_9Z4BYR88imo/TQTQbo-LQJI/AAAAAAAAAfk/YnnnPAQE-R4/s800/NoWrapTextPane.png)

### サンプルコード
<pre class="prettyprint"><code>class NoWrapParagraphView extends ParagraphView {
  public NoWrapParagraphView(Element elem) {
    super(elem);
  }
  @Override protected SizeRequirements calculateMinorAxisRequirements(
      int axis, SizeRequirements r) {
    SizeRequirements req = super.calculateMinorAxisRequirements(axis, r);
    req.minimum = req.preferred;
    return req;
  }
  @Override public int getFlowSpan(int index) {
    return Integer.MAX_VALUE;
  }
}
</code></pre>

### 解説
上記のサンプルでは、スパンの必要サイズを計算する`calculateMinorAxisRequirements`メソッドなどをオーバーライドして、行折り返し段落のビュー(`ParagraphView`)で折り返しが発生しないようにしています。

`JEditorPane`や`JTextPane`といった`StyledDocument`をモデルにしているテキストコンポーネントに非常に長い行をペーストした場合、表示が更新されなくなりますが、折り返しできなくしてしまうと多少ましになるようです。

`JTextArea`でも行を非常に長くしてしまうと、カーソルキーの移動などで異常に時間がかかる場合があります。

- 例えば、このサンプルで、カーソルを一番最後に移動し、一行目(非常に長い行)に<kbd>Up</kbd>キーで移動すると発生する
- [Swing - Long last line in wrappable textarea hangs GUI (bug in java?)](https://forums.oracle.com/message/5776978)

<!-- dummy comment line for breaking list -->

- - - -
以下のような方法もあります。
- [Swing - Disabling word wrap for JTextPane](https://forums.oracle.com/forums/thread.jspa?threadID=1351861)
    - `BoxView#layout(...)`をオーバーライド
- [Non Wrapping(Wrap) TextPane : TextField : Swing JFC : Java examples (example source code) Organized by topic](http://www.java2s.com/Code/Java/Swing-JFC/NonWrappingWrapTextPane.htm)
    - `JTextPane#getScrollableTracksViewportWidth()`をオーバーライド

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Swing - Disabling word wrap for JTextPane](https://forums.oracle.com/forums/thread.jspa?threadID=1351861)
- [Non Wrapping(Wrap) TextPane : TextField : Swing JFC : Java examples (example source code) Organized by topic](http://www.java2s.com/Code/Java/Swing-JFC/NonWrappingWrapTextPane.htm)
- [Bug ID: 6502558 AbstractDocument fires event not on Event Dispatch Thread](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=6502558)
    - [Alexander Potochkin's Blog: Debugging Swing, the final summary](http://weblogs.java.net/blog/alexfromsun/archive/2006/02/debugging_swing.html)
- [JTextPaneを一行に制限してスタイル可能なJTextFieldとして使用する](http://terai.xrea.jp/Swing/OneLineTextPane.html)

<!-- dummy comment line for breaking list -->

### コメント