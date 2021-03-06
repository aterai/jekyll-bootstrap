---
layout: post
category: swing
folder: NoWrapTextPane
title: JEditorPaneで長い行を折り返さない
tags: [JEditorPane, JTextPane, StyledDocument]
author: aterai
pubdate: 2007-09-24T18:04:06+09:00
description: JEditorPaneや、JTextPaneで、行をViewportの幅で折り返さないよう設定します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQbo-LQJI/AAAAAAAAAfk/YnnnPAQE-R4/s800/NoWrapTextPane.png
comments: true
---
## 概要
`JEditorPane`や、`JTextPane`で、行を`Viewport`の幅で折り返さないよう設定します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTQbo-LQJI/AAAAAAAAAfk/YnnnPAQE-R4/s800/NoWrapTextPane.png %}

## サンプルコード
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

## 解説
上記のサンプルでは、スパンの必要サイズを計算する`calculateMinorAxisRequirements`メソッドなどをオーバーライドして、行折り返し段落のビュー(`ParagraphView`)で折り返しが発生しないように設定しています。

- `JEditorPane`や`JTextPane`といった`StyledDocument`をモデルにしているテキストコンポーネントに極めて長い行をペーストすると表示が更新されなくなる場合がある
    - 折り返し不可に設定するとこの動作が緩和される？
- `JTextArea`でも行を極めて長くしてしまうと、カーソルキーの移動などで異常に時間がかかる場合がある
    - 例えば、このサンプルの`JTextArea`で、カーソルを末尾(`EOF`)に移動し、一行目(非常に長い行)に<kbd>Up</kbd>キーで移動すると発生する
    - [Swing - Long last line in wrappable textarea hangs GUI (bug in java?)](https://community.oracle.com/thread/1367888)

<!-- dummy comment line for breaking list -->

- - - -
- [Swing - Disabling word wrap for JTextPane](https://community.oracle.com/thread/1353861)
    - `BoxView#layout(...)`をオーバーライドして折り返しを不可に設定
- [Non Wrapping(Wrap) TextPane : TextField : Swing JFC : Java examples (example source code) Organized by topic](http://www.java2s.com/Code/Java/Swing-JFC/NonWrappingWrapTextPane.htm)
    - `JTextPane#getScrollableTracksViewportWidth()`をオーバーライドして折り返しを不可に設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - Disabling word wrap for JTextPane](https://community.oracle.com/thread/1353861)
- [Non Wrapping(Wrap) TextPane : TextField : Swing JFC : Java examples (example source code) Organized by topic](http://www.java2s.com/Code/Java/Swing-JFC/NonWrappingWrapTextPane.htm)
- [Bug ID: 6502558 AbstractDocument fires event not on Event Dispatch Thread](https://bugs.openjdk.java.net/browse/JDK-6502558)
    - [Alexander Potochkin's Blog: Debugging Swing, the final summary](http://weblogs.java.net/blog/alexfromsun/archive/2006/02/debugging_swing.html)
- [JTextPaneを一行に制限してスタイル可能なJTextFieldとして使用する](https://ateraimemo.com/Swing/OneLineTextPane.html)

<!-- dummy comment line for breaking list -->

## コメント
