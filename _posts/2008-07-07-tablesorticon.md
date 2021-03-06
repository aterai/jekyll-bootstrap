---
layout: post
category: swing
folder: TableSortIcon
title: JTableのソートアイコンを変更
tags: [JTable, JTableHeader, Icon, UIManager]
author: aterai
pubdate: 2008-07-07T11:40:12+09:00
description: JTableのソートアイコンを非表示にしたり、別の画像に変更します。
image: https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUsaUYVkI/AAAAAAAAAmc/34Qz14LqOGc/s800/TableSortIcon.png
comments: true
---
## 概要
`JTable`のソートアイコンを非表示にしたり、別の画像に変更します。

{% download https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTUsaUYVkI/AAAAAAAAAmc/34Qz14LqOGc/s800/TableSortIcon.png %}

## サンプルコード
<pre class="prettyprint"><code>Icon emptyIcon = new Icon() {
  @Override public void paintIcon(Component c, Graphics g, int x, int y) {}

  @Override public int getIconWidth(){
    return 0;
  }

  @Override public int getIconHeight() {
    return 0;
  }
};
UIManager.put("Table.ascendingSortIcon", new IconUIResource(emptyIcon));
UIManager.put("Table.descendingSortIcon", new IconUIResource(emptyIcon));
</code></pre>

## 解説
上記のサンプルでは、`UIManager`を使用して`JTable`のヘッダに表示されるソートアイコンを変更しています。

- `Default`
    - `UIManager.getLookAndFeelDefaults().getIcon("Table.ascendingSortIcon")`などで取得した`LookAndFeel`でのデフォルトソートアイコンを表示
- `Empty`
    - サイズ`0`の`Icon`でソートアイコンを非表示化
- `Custom`
    - 透過`png`画像から生成したソートアイコンを表示

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Icon (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/Icon.html)
- [UIManager#getLookAndFeelDefaults() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/UIManager.html#getLookAndFeelDefaults--)

<!-- dummy comment line for breaking list -->

## コメント
