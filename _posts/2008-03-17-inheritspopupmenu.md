---
layout: post
category: swing
folder: InheritsPopupMenu
title: JPopupMenuの取得を親に委譲
tags: [JPopupMenu, JScrollPane, JViewport, JTable, JTableHeader]
author: aterai
pubdate: 2008-03-17T13:34:51+09:00
description: 親コンポーネントに設定されているJPopupMenuを取得して、これを表示します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTOe9ph-LI/AAAAAAAAAcc/iwxbgnjvxg8/s800/InheritsPopupMenu.png
comments: true
---
## 概要
親コンポーネントに設定されている`JPopupMenu`を取得して、これを表示します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTOe9ph-LI/AAAAAAAAAcc/iwxbgnjvxg8/s800/InheritsPopupMenu.png %}

## サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll = new JScrollPane(table);
scroll.setComponentPopupMenu(new TablePopupMenu());
// scroll.getViewport().setInheritsPopupMenu(true); // JDK 1.5
table.setInheritsPopupMenu(true);
// table.getTableHeader().setInheritsPopupMenu(true);

// ...
private class TablePopupMenu extends JPopupMenu {
  private final Action deleteAction = new DeleteAction("delete", null);
  private final Action createAction = new CreateAction("add", null);

  public TablePopupMenu() {
    super();
    add(createAction);
    addSeparator();
    add(deleteAction);
  }

  @Override public void show(Component c, int x, int y) {
    deleteAction.setEnabled(table.getSelectedRowCount() &gt; 0);
    super.show(c, x, y);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JScrollPane`に`setComponentPopupMenu(JPopupMenu)`メソッドでポップアップメニューを追加し、`JTable`側には`setInheritsPopupMenu(true)`とすることで親の`JScrollPane`に設定したポップアップメニューを使用するよう設定しています。

- - - -
- `JDK 1.5`では`JViewport`も`setInheritsPopupMenu(true)`とする必要があったが、`JDK 1.6`ではデフォルトが変更されて不要になった
- `JDK 1.6`では`JTable`のヘッダも`setInheritsPopupMenu(true)`で、`JScrollPane`からポップアップメニューを取得して表示可能
    - ~~`JDK 1.6` + `WindowsLookAndFeel`で`JTableHeader`上にポップアップメニューを表示すると、以下のようにうまく再描画できない場合がある~~ 修正済み

<!-- dummy comment line for breaking list -->
1. ヘッダを右クリックしながら、右端にドラッグ、ポップアップ表示
1. <kbd>Esc</kbd>キーで、ポップアップ非表示
1. ヘッダ上で右クリック、ポップアップ、<kbd>Esc</kbd>キー


## 参考リンク
- [JComponent#setInheritsPopupMenu(boolean) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JComponent.html#setInheritsPopupMenu-boolean-)
- [JPopupMenuをコンポーネントに追加](https://ateraimemo.com/Swing/ComponentPopupMenu.html)

<!-- dummy comment line for breaking list -->

## コメント
