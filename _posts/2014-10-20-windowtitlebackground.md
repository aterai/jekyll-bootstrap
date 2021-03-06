---
layout: post
category: swing
folder: WindowTitleBackground
title: JFrameがデフォルトのウィンドウ装飾を使用する場合のタイトルバー背景色を変更
tags: [JFrame, UIManager]
author: aterai
pubdate: 2014-10-20T00:23:21+09:00
description: JFrameがデフォルトのウィンドウ装飾を使用する場合、タイトルバーの文字色、背景色などを変更します。
image: https://lh5.googleusercontent.com/-kMDDoLGWoSA/VEPUosVXWPI/AAAAAAAACQw/94kmPEN2CT8/s800/WindowTitleBackground.png
comments: true
---
## 概要
`JFrame`がデフォルトのウィンドウ装飾を使用する場合、タイトルバーの文字色、背景色などを変更します。

{% download https://lh5.googleusercontent.com/-kMDDoLGWoSA/VEPUosVXWPI/AAAAAAAACQw/94kmPEN2CT8/s800/WindowTitleBackground.png %}

## サンプルコード
<pre class="prettyprint"><code>Object[][] data = {
  {"activeCaption",         UIManager.getColor("activeCaption")},
  {"activeCaptionBorder",   UIManager.getColor("activeCaptionBorder")},
  {"activeCaptionText",     UIManager.getColor("activeCaptionText")},
  {"control",               UIManager.getColor("control")},
  {"controlDkShadow",       UIManager.getColor("controlDkShadow")},
  {"controlHighlight",      UIManager.getColor("controlHighlight")},
  {"controlLtHighlight",    UIManager.getColor("controlLtHighlight")},
  {"controlShadow",         UIManager.getColor("controlShadow")},
  {"controlText",           UIManager.getColor("controlText")},
  {"desktop",               UIManager.getColor("desktop")},
  {"inactiveCaption",       UIManager.getColor("inactiveCaption")},
  {"inactiveCaptionBorder", UIManager.getColor("inactiveCaptionBorder")},
  {"inactiveCaptionText",   UIManager.getColor("inactiveCaptionText")},
  {"info",                  UIManager.getColor("info")},
  {"infoText",              UIManager.getColor("infoText")},
  {"menu",                  UIManager.getColor("menu")},
  {"menuText",              UIManager.getColor("menuText")},
  {"scrollbar",             UIManager.getColor("scrollbar")},
  {"text",                  UIManager.getColor("text")},
  {"textHighlight",         UIManager.getColor("textHighlight")},
  {"textHighlightText",     UIManager.getColor("textHighlightText")},
  {"textInactiveText",      UIManager.getColor("textInactiveText")},
  {"textText",              UIManager.getColor("textText")},
  {"window",                UIManager.getColor("window")},
  {"windowBorder",          UIManager.getColor("windowBorder")},
  {"windowText",            UIManager.getColor("windowText")}
};
DefaultTableModel model = new DefaultTableModel(data, columnNames) {
  @Override public boolean isCellEditable(int row, int column) {
    return column == 1;
  }

  @Override public Class&lt;?&gt; getColumnClass(int column) {
    return getValueAt(0, column).getClass();
  }
};
JTable table = new JTable(model);

// ...
model.addTableModelListener(new TableModelListener() {
  @Override public void tableChanged(TableModelEvent e) {
    if (e.getType() == TableModelEvent.UPDATE &amp;&amp; e.getColumn() == 1) {
      int row = e.getFirstRow();
      String key = (String) model.getValueAt(row, 0);
      Color color = (Color) model.getValueAt(row, 1);
      UIManager.put(key, new ColorUIResource(color));
      EventQueue.invokeLater(new Runnable() {
        @Override public void run() {
          Window w = SwingUtilities.getWindowAncestor(table);
          SwingUtilities.updateComponentTreeUI(w);
        }
      });
    }
  }
});
</code></pre>

## 解説
上記のサンプルでは、`JFrame`がデフォルトのウィンドウ装飾を使用するように`JFrame.setDefaultLookAndFeelDecorated(true);`を指定し、`UIManager.setColor(...)`メソッドを使用してタイトルバーの文字色、背景色を変更するテストを行っています。

- `activeCaption`: タイトルバーの背景色
- `activeCaptionBorder`: タイトルバーの`Border`の色
- `activeCaptionText`: タイトルバーの文字色

<!-- dummy comment line for breaking list -->

## 参考リンク
- [SystemColorの使用](https://ateraimemo.com/Swing/SystemColor.html)
- [SystemColor (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/SystemColor.html)
- [MetalLookAndFeel#initSystemColorDefaults(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/metal/MetalLookAndFeel.html#initSystemColorDefaults-javax.swing.UIDefaults-)
- [MetalTheme (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/plaf/metal/MetalTheme.html)

<!-- dummy comment line for breaking list -->

## コメント
