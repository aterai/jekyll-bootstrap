---
layout: post
category: swing
folder: InsertComponentBaseline
title: JTextPaneに追加するコンポーネントのベースラインを揃える
tags: [JTextPane, JComponent, Baseline]
author: aterai
pubdate: 2012-09-03T06:06:39+09:00
description: JTextPaneに追加するコンポーネントのベースラインが他の文字列などとを揃うように設定します。
image: https://lh3.googleusercontent.com/-JveOiooEbAg/UEPEjv1VW2I/AAAAAAAABR4/qts-97h_JuA/s800/InsertComponentBaseline.png
comments: true
---
## 概要
`JTextPane`に追加するコンポーネントのベースラインが他の文字列などとを揃うように設定します。

{% download https://lh3.googleusercontent.com/-JveOiooEbAg/UEPEjv1VW2I/AAAAAAAABR4/qts-97h_JuA/s800/InsertComponentBaseline.png %}

## サンプルコード
<pre class="prettyprint"><code>JCheckBox check1 = new JCheckBox("JComponent.setAlignmentY(...)");
Dimension d = check1.getPreferredSize();
int baseline = check1.getBaseline(d.width, d.height);
check1.setAlignmentY(baseline / (float) d.height);
textPane.replaceSelection("\n\n Baseline: ");
textPane.insertComponent(check1);
</code></pre>

## 解説
- `Default`
    - `JTextPane#insertComponent(...)`メソッドで、`JCheckBox`を追加
    - `JCheckBox`のデフォルトの`AlignmentY`は`0.5`なのでテキストのベースラインと揃わない
- `JComponent#setAlignmentY(...)`
    - `JComponent#getBaseline()`メソッドでベースラインを取得し、`JComponent#setAlignmentY(baseline/(float)d.height)`メソッドでテキストベースラインの相対位置に配置
- `setAlignmentY+setCursor+...`
    - `JComponent#setAlignmentY(...)`メソッドの使用と合わせて`Cursor + Opaque + Focusable`を設定
        
        <pre class="prettyprint"><code>check2.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
        check2.setOpaque(false);
        check2.setFocusable(false);
</code></pre>
    - * 参考リンク [#reference]
- [JTextPane#insertComponent(Component) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTextPane.html#insertComponent-java.awt.Component-)

<!-- dummy comment line for breaking list -->
<blockquote><p>
 コンポーネントは、`Component.getAlignmentY`によって返された値に従って、テキストベースラインに相対的に配置されます。`Swing`コンポーネントの場合、`JComponent.setAlignmentY`メソッドを使うと、この値を簡単に設定できます。たとえば、値を`0.75`に設定すると、コンポーネントの`75%`がベースラインの上に、`25%`がベースラインの下になります。
</p></blockquote>

- [java - How to appropriately adding JLabel to JEditorPane? - Stack Overflow](https://stackoverflow.com/questions/12151158/how-to-appropriately-adding-jlabel-to-jeditorpane)

<!-- dummy comment line for breaking list -->

## コメント
