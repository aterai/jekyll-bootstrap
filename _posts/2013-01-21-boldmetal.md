---
layout: post
category: swing
folder: BoldMetal
title: MetalLookAndFeelで太字フォントを使用しない
tags: [MetalLookAndFeel, LookAndFeel, Font, UIManager, Html]
author: aterai
pubdate: 2013-01-21T00:02:35+09:00
description: MetalLookAndFeelで太字フォントを使用しないように設定します。
comments: true
---
## 概要
`MetalLookAndFeel`で太字フォントを使用しないように設定します。

{% download https://lh4.googleusercontent.com/-7wQtHGyNRDQ/UPv6YyOBReI/AAAAAAAABbk/_vXFoJwk-ug/s800/BoldMetal.png %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("swing.boldMetal", Boolean.FALSE);
</code></pre>

## 解説
上記のサンプルでは、`UIManager.put("swing.boldMetal", Boolean.FALSE);`として、`JLabel`、`JButton`、`TitleBorder`などのデフォルトとしてボールド(太字)フォントを使用しないように設定しています。

システムプロパティー`swing.boldMetal`を`false`に設定する方法でもボールド(太字)フォントを使用しないように設定することができます。

	> java -Dswing.boldMetal=false example.MainPanel

- デフォルトプロパティー`swing.boldMetal`が、システムプロパティー`swing.boldMetal`より優先される
- `Html`で`<html><b>...</b></html>`のように装飾した場合は、デフォルトプロパティー`swing.boldMetal`より優先される(このサンプルでは、`JTabbedPane`の選択タブタイトルを`<html><b>...</b></html>`で装飾)
- 以下のようにデフォルトプロパティー`swing.boldMetal`を更新することで切り替え可能
    - [DefaultMetalTheme (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/api/docs/javax/swing/plaf/metal/DefaultMetalTheme.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JCheckBox check = new JCheckBox("swing.boldMetal");
check.addActionListener(new ActionListener() {
  @Override public void actionPerformed(ActionEvent e) {
    JCheckBox c = (JCheckBox) e.getSource();
    UIManager.put("swing.boldMetal", c.isSelected());
    // re-install the Metal Look and Feel
    try {
      UIManager.setLookAndFeel(new MetalLookAndFeel());
    } catch (Exception ex) {
      ex.printStackTrace();
    }
    // Update the ComponentUIs for all Components. This
    // needs to be invoked for all windows.
    SwingUtilities.updateComponentTreeUI(SwingUtilities.getWindowAncestor(c));
  }
});
</code></pre>

## 参考リンク
- [DefaultMetalTheme (Java Platform SE 8)](http://docs.oracle.com/javase/jp/8/api/docs/javax/swing/plaf/metal/DefaultMetalTheme.html)

<!-- dummy comment line for breaking list -->

## コメント
