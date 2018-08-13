---
layout: post
category: swing
folder: SynthLookAndFeel
title: SynthのスタイルをXMLファイルで設定する
tags: [SynthLookAndFeel, LookAndFeel]
author: aterai
pubdate: 2018-08-13T14:59:12+09:00
description: SynthLookAndFeelのスタイルをXMLファイルで設定します。
image: https://drive.google.com/uc?id=1yPNRdiUSVu_8dPLvMFdctKzE9Tnp-hSXDA
comments: true
---
## 概要
`SynthLookAndFeel`のスタイルを`XML`ファイルで設定します。

{% download https://drive.google.com/uc?id=1yPNRdiUSVu_8dPLvMFdctKzE9Tnp-hSXDA %}

## サンプルコード
<pre class="prettyprint"><code>Class&lt;?&gt; clz = MainPanel.class;
try (InputStream is = clz.getResourceAsStream("button.xml")) {
  SynthLookAndFeel synth = new SynthLookAndFeel();
  synth.load(is, clz);
  UIManager.setLookAndFeel(synth);
} catch (IOException | ParseException | UnsupportedLookAndFeelException ex) {
  ex.printStackTrace();
}
</code></pre>

## 解説
上記のサンプルでは、以下のような`XML`ファイルで`SynthLookAndFeel`のスタイルを設定しています。

<pre class="prettyprint"><code>&lt;synth&gt;
  &lt;style id="default"&gt;
    &lt;font name="Dialog" size="16" /&gt; 
  &lt;/style&gt;
  &lt;bind style="default" type="region" key=".*" /&gt;
  &lt;style id="ButtonTest"&gt;
    &lt;opaque value="true" /&gt;
    &lt;insets top="10" bottom="10" left="10" right="10" /&gt;
    &lt;state&gt;
      &lt;font name="Verdana" size="24" /&gt;
      &lt;color type="BACKGROUND" value="#FF0000" /&gt;
      &lt;color type="TEXT_FOREGROUND" value="#000000" /&gt;
    &lt;/state&gt;
    &lt;state value="MOUSE_OVER"&gt;
      &lt;color type="BACKGROUND" value="ORANGE" /&gt;
      &lt;color type="TEXT_FOREGROUND" value="WHITE" /&gt;
    &lt;/state&gt;
    &lt;state value="PRESSED"&gt;
      &lt;color type="BACKGROUND" value="BLUE" /&gt;
      &lt;color type="TEXT_FOREGROUND" value="WHITE" /&gt;
    &lt;/state&gt;
  &lt;/style&gt;
  &lt;bind style="ButtonTest" type="region" key="button" /&gt;

  &lt;style id="greenButton"&gt;
    &lt;opaque value="true" /&gt;
    &lt;insets top="10" bottom="10" left="10" right="10" /&gt;
    &lt;state&gt;
      &lt;font name="Verdana" size="24" /&gt;
      &lt;color type="BACKGROUND" value="GREEN" /&gt;
      &lt;color type="TEXT_FOREGROUND" value="#000000" /&gt;
    &lt;/state&gt;
    &lt;state value="MOUSE_OVER"&gt;
      &lt;color type="BACKGROUND" value="RED" /&gt;
      &lt;color type="TEXT_FOREGROUND" value="WHITE" /&gt;
    &lt;/state&gt;
    &lt;state value="PRESSED"&gt;
      &lt;color type="BACKGROUND" value="BLUE" /&gt;
      &lt;color type="TEXT_FOREGROUND" value="WHITE" /&gt;
    &lt;/state&gt;
  &lt;/style&gt;
  &lt;bind style="greenButton" type="name" key="green:[0-9]+" /&gt;
&lt;/synth&gt;
</code></pre>

`Synth`の`XML`ファイルの詳細(`DTD`など)は、[Synthのファイル形式](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/synth/doc-files/synthFileFormat.html)で参照できます。

- - - -
- 特定のコンポーネントにスタイルを設定する場合は、`bind`要素の`type`属性に`key`ではなく`name`を設定して、`key`属性に対象コンポーネントに`Component#setName(...)`で設定された名前を正規表現で指定する
    - 例: `<bind style="greenButton" type="name" key="green:[0-9]+" />`で名前が`button3.setName("green:3");`のような形式になっているコンポーネントに`greenButton`スタイルが適用される
    - [進歩したSynth - IBM developerWorks](https://www.ibm.com/developerworks/jp/java/library/j-synth/index.html)について
        - 「非`Swing`コンポーネントをペイントする」で`bind`要素の`type`属性に`key`ではなく`name`を設定した場合の説明があるが、`Java 8`のソースコード(`javax/swing/plaf/synth/DefaultSynthStyleFactory#getMatchingStyles(...)`)を確認した限りではコンポーネントのクラス名を対象にする機能は存在しない(`1.4`では可能だった？のかもしれない)

<!-- dummy comment line for breaking list -->
<blockquote><p>
 `<bind>`タグを`<bind style="mystyle" type="name" key="Custom.*"/>`に変更すると、`mystyle`スタイルを使うためには、クラス名が`Custom`で始まる全コンポーネント（例えば`CustomTextField`や`CustomLabel`など）を変更することになります。
</p></blockquote>

## 参考リンク
- [The Synth Look and Feel (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/synth.html)
- [進歩したSynth](https://www.ibm.com/developerworks/jp/java/library/j-synth/index.html)
    - 現在は無効になっている「`<bind>`要素のクラス名関係」以外は正確で有用と思われる

<!-- dummy comment line for breaking list -->

## コメント
