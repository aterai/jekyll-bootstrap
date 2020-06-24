---
layout: post
category: swing
folder: ExportToClipboard
title: JList間でのコピー＆ペーストによるアイテムの移動
tags: [JList, TransferHandler, Clipboard, JPopupMenu]
author: aterai
pubdate: 2018-05-21T17:27:59+09:00
description: JList間でコピー＆ペーストによるアイテムの複製・移動を行います。
image: https://drive.google.com/uc?id=1wNH_7qaS-YirfMG-vli1p7sETt3v5oaciA
hreflang:
    href: https://java-swing-tips.blogspot.com/2018/06/move-items-by-copying-and-pasting.html
    lang: en
comments: true
---
## 概要
`JList`間でコピー＆ペーストによるアイテムの複製・移動を行います。

{% download https://drive.google.com/uc?id=1wNH_7qaS-YirfMG-vli1p7sETt3v5oaciA %}

## サンプルコード
<pre class="prettyprint"><code>class ListPopupMenu extends JPopupMenu {
  private final JMenuItem cutItem;
  private final JMenuItem copyItem;
  protected ListPopupMenu(JList&lt;?&gt; list) {
    super();
    Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
    TransferHandler handler = list.getTransferHandler();
    cutItem = add("cut");
    cutItem.addActionListener(e -&gt; {
      handler.exportToClipboard(list, clipboard, TransferHandler.MOVE);
    });
    copyItem = add("copy");
    copyItem.addActionListener(e -&gt; {
      handler.exportToClipboard(list, clipboard, TransferHandler.COPY);
    });
    add("paste").addActionListener(e -&gt; {
      handler.importData(list, clipboard.getContents(null));
    });
    addSeparator();
    add("clearSelection").addActionListener(e -&gt; list.clearSelection());
  }

  @Override public void show(Component c, int x, int y) {
    if (c instanceof JList) {
      boolean isSelected = !((JList&lt;?&gt;) c).isSelectionEmpty();
      cutItem.setEnabled(isSelected);
      copyItem.setEnabled(isSelected);
      super.show(c, x, y);
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、[TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)を元にし、ドラッグ＆ドロップに加えてクリップボード経由でのアイテム移動や複製が可能になるような`ListItemTransferHandler`を作成して、`JList`に設定しています。

- [TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)では`TransferHandler.TransferSupport#isDrop()`が`false`の場合はインポート不可(`TransferHandler#canImport(...) == false`)とし、また`ActionMap`でもキーボードによるコピーなどを無効に設定
- このサンプルでは`TransferHandler.TransferSupport#isDrop()`が`false`の場合、以下のようにキーボード入力や`JPopupMenu`からのカット、コピー、ペーストと判断して`JList#getSelectedIndex()`で取得した位置にアイテムを貼り込むように変更
    
    <pre class="prettyprint"><code>private static int getIndex(TransferHandler.TransferSupport info) {
      JList&lt;?&gt; target = (JList&lt;?&gt;) info.getComponent();
      int index; // = dl.getIndex();
      if (info.isDrop()) { // Mouse Drag &amp; Drop
        System.out.println("Mouse Drag &amp; Drop");
        TransferHandler.DropLocation tdl = info.getDropLocation();
        if (tdl instanceof JList.DropLocation) {
          index = ((JList.DropLocation) tdl).getIndex();
        } else {
          index = target.getSelectedIndex();
        }
      } else { // Keyboard Copy &amp; Paste
        index = target.getSelectedIndex();
      }
      DefaultListModel&lt;?&gt; listModel = (DefaultListModel&lt;?&gt;) target.getModel();
      // boolean insert = dl.isInsert();
      int max = listModel.getSize();
      // int index = dl.getIndex();
      index = index &lt; 0 ? max : index; // If it is out of range, it is appended to the end
      index = Math.min(index, max);
      return index;
    }
</code></pre>
- * 参考リンク [#reference]
- [TransferHandler.TransferSupport#isDrop() (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/TransferHandler.TransferSupport.html#isDrop--)
- [TransferHandlerを使ったJListのドラッグ＆ドロップによる並べ替え](https://ateraimemo.com/Swing/DnDReorderList.html)

<!-- dummy comment line for breaking list -->

## コメント
