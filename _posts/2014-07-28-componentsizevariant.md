---
layout: post
category: swing
folder: ComponentSizeVariant
title: NimbusLookAndFeelでJComponentのサイズを変更する
tags: [NimbusLookAndFeel, JComponent, Font]
author: aterai
pubdate: 2014-07-28T00:18:57+09:00
description: NimbusLookAndFeelを使用している場合、コンポーネントの表示サイズをクライアントプロパティ設定で変更可能です。
image: https://lh6.googleusercontent.com/-Uru9Oco4olg/U9T5RHzJ_5I/AAAAAAAACKY/7N7a3Ya3sYw/s800/ComponentSizeVariant.png
comments: true
---
## 概要
`NimbusLookAndFeel`を使用している場合、コンポーネントの表示サイズをクライアントプロパティ設定で変更可能です。

{% download https://lh6.googleusercontent.com/-Uru9Oco4olg/U9T5RHzJ_5I/AAAAAAAACKY/7N7a3Ya3sYw/s800/ComponentSizeVariant.png %}

## サンプルコード
<pre class="prettyprint"><code>booleanRenderer.putClientProperty("JComponent.sizeVariant", "mini");
</code></pre>

## 解説
- `NimbusLookAndFeel`を使用している場合、`JComponent#putClientProperty("JComponent.sizeVariant", "mini");`のようにクライアントプロパティを設定することでコンポーネントの表示サイズが変更可能
    - デフォルトは`regular`、その他は小さい順に`mini`, `small`, `large`が設定可能
    - `JComponent#updateUI()`を実行しないと、更新されない
        - このサンプルでは、`SwingUtilities.updateComponentTreeUI(window);`で実行
    - コンポーネントにフォントがユーザ指定されている場合は、文字サイズは更新されない
        - このサンプルでは、`updateUI()`の前に、フォントを`jc.setFont(new FontUIResource(jc.getFont()));`で`UIResource`化することで回避
    - `JTable`の`BooleanRenderer`が二回目以降変更されない
        - 初回の`JCheckBox booleanRenderer = (JCheckBox) table.getDefaultRenderer(Boolean.class); booleanRenderer.putClientProperty("JComponent.sizeVariant", "mini");`は、正常に動作しているように見える

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Resizing a Component (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/size.html)

<!-- dummy comment line for breaking list -->

## コメント
