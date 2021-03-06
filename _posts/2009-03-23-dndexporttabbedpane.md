---
layout: post
category: swing
folder: DnDExportTabbedPane
title: JTabbedPane間でタブのドラッグ＆ドロップ移動
tags: [JTabbedPane, TransferHandler, DragAndDrop, GlassPane, Cursor]
author: aterai
pubdate: 2009-03-23T14:24:48+09:00
description: JTabbedPane間でタブのDrag&Dropによる移動を行います。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLW06ZMXI/AAAAAAAAAXc/vzeXm4pwhVY/s800/DnDExportTabbedPane.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2010/02/tabtransferhandler.html
    lang: en
comments: true
---
## 概要
`JTabbedPane`間でタブの`Drag&Drop`による移動を行います。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTLW06ZMXI/AAAAAAAAAXc/vzeXm4pwhVY/s800/DnDExportTabbedPane.png %}

## サンプルコード
<pre class="prettyprint"><code>class TabTransferHandler extends TransferHandler {
  private final DataFlavor localObjectFlavor = new DataFlavor(DnDTabData.class, "DnDTabData");
  private DnDTabbedPane source = null;

  @Override protected Transferable createTransferable(JComponent c) {
    System.out.println("createTransferable");
    if (c instanceof DnDTabbedPane) source = (DnDTabbedPane) c;
    return new Transferable() {
      @Override public DataFlavor[] getTransferDataFlavors() {
        return new DataFlavor[] {localObjectFlavor};
      }
      @Override public boolean isDataFlavorSupported(DataFlavor flavor) {
        return Objects.equals(localObjectFlavor, flavor);
      }
      @Override public Object getTransferData(DataFlavor flavor) 
            throws UnsupportedFlavorException, IOException {
        if (isDataFlavorSupported(flavor)) {
          return new DnDTabData(source);
        } else {
           throw new UnsupportedFlavorException(flavor);
        }
      }
    };
  }

  @Override public boolean canImport(TransferSupport support) {
    //System.out.println("canImport");
    if (!support.isDrop() || !support.isDataFlavorSupported(localObjectFlavor)) {
      return false;
    }
    support.setDropAction(TransferHandler.MOVE);
    DropLocation tdl = support.getDropLocation();
    Point pt = tdl.getDropPoint();
    DnDTabbedPane target = (DnDTabbedPane) support.getComponent();
    target.autoScrollTest(pt);
    DnDTabbedPane.DropLocation dl =
      (DnDTabbedPane.DropLocation) target.dropLocationForPoint(pt);
    int idx = dl.getIndex();
    boolean isDroppable = false;

    if (target == source) {
      isDroppable = target.getTabAreaBounds().contains(pt) &amp;&amp; idx &gt;= 0 &amp;&amp;
                   idx != target.dragTabIndex &amp;&amp; idx != target.dragTabIndex + 1;
    } else {
      if (source != null &amp;&amp; target != source.getComponentAt(source.dragTabIndex)) {
        isDroppable = target.getTabAreaBounds().contains(pt) &amp;&amp; idx &gt;= 0;
      }
    }

    Component c = target.getRootPane().getGlassPane();
    c.setCursor(isDroppable?DragSource.DefaultMoveDrop:DragSource.DefaultMoveNoDrop);
    if (isDroppable) {
      support.setShowDropLocation(true);
      dl.setDroppable(true);
      target.setDropLocation(dl, null, true);
      return true;
    } else {
      support.setShowDropLocation(false);
      dl.setDroppable(false);
      target.setDropLocation(dl, null, false);
      return false;
    }
  }

  private BufferedImage makeDragTabImage(DnDTabbedPane tabbedPane) {
    Rectangle rect = tabbedPane.getBoundsAt(tabbedPane.dragTabIndex);
    BufferedImage image = new BufferedImage(
      tabbedPane.getWidth(), tabbedPane.getHeight(), BufferedImage.TYPE_INT_ARGB);
    Graphics g = image.getGraphics();
    tabbedPane.paint(g);
    g.dispose();
    if (rect.x &lt; 0) {
      rect.translate(-rect.x, 0);
    }
    if (rect.y &lt; 0) {
      rect.translate(0, -rect.y);
    }
    if (rect.x + rect.width &gt; image.getWidth()) {
      rect.width = image.getWidth() - rect.x;
    }
    if (rect.y + rect.height &gt; image.getHeight()) {
      rect.height = image.getHeight() - rect.y;
    }
    return image.getSubimage(rect.x, rect.y, rect.width, rect.height);
  }

  @Override public int getSourceActions(JComponent c) {
    System.out.println("getSourceActions");
    if (c instanceof DnDTabbedPane) {
      DnDTabbedPane src = (DnDTabbedPane) c;
      c.getRootPane().setGlassPane(new GhostGlassPane(src));
      if (src.dragTabIndex &lt; 0) {
        return TransferHandler.NONE;
      }
      setDragImage(makeDragTabImage(src));
      c.getRootPane().getGlassPane().setVisible(true);
      return TransferHandler.MOVE;
    }
    return TransferHandler.NONE;
  }

  @Override public boolean importData(TransferSupport support) {
    System.out.println("importData");

    DnDTabbedPane target = (DnDTabbedPane) support.getComponent();
    DnDTabbedPane.DropLocation dl = target.getDropLocation();
    try {
      DnDTabbedPane source = (DnDTabbedPane) support.getTransferable()
        .getTransferData(localObjectFlavor);
      int index = dl.getIndex(); //boolean insert = dl.isInsert();
      if (target == source) {
        source.convertTab(source.dragTabIndex, index);
      } else {
        source.exportTab(source.dragTabIndex, target, index);
      }
      return true;
    } catch (UnsupportedFlavorException ufe) {
      ufe.printStackTrace();
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }
    return false;
  }

  @Override protected void exportDone(JComponent c, Transferable data, int action) {
    System.out.println("exportDone");
    DnDTabbedPane src = (DnDTabbedPane) c;
    c.getRootPane().getGlassPane().setVisible(false);
    src.setDropLocation(null, null, false);
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JDK 6`で導入された、`TransferHandler.DropLocation`を継承する`DnDTabbedPane.DropLocation`などを作成して、`JTabbedPane`間でタブの移動ができるように設定しています。

- 注意点
    - 自身の子として配置されている`JTabbedPane`にタブを移動することはできない
    - 子コンポーネントが`null`(例えば`addTab("Tab",null)`)のタブは移動不可
    - タブが選択不可(例えば`setEnabledAt(idx, false)`)の場合は移動不可
- バグ？
    - ~~子コンポーネントが`JTable`の場合、マウスカーソルが点滅する~~
        - ~~`Windows`環境のみ？~~
    - 子コンポーネントが`JTextArea`などの場合、ドラッグ中のタブゴーストが表示できない
        - ~~`JTable`、`JTextArea`どちらも、`JScrollPane`が影響している？~~
        - `Java 1.7.0-ea-b84`以上で、`TransferHandler#setDragImage(Image)`を使用すると正常に表示される
        - `textArea.setTransferHandler(null);`とすれば、`1.6.0`でも正常に表示される
    - `SCROLL_TAB_LAYOUT`の場合、タブゴーストにスクロールボタンが表示される場合がある

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTLZe_UIkI/AAAAAAAAAXg/bCzrlm037N8/s800/DnDExportTabbedPane1.png)

## 参考リンク
- [JTabbedPaneのタブをドラッグ＆ドロップ](https://ateraimemo.com/Swing/DnDTabbedPane.html)
- [JLayerを使ってJTabbedPaneのタブの挿入位置を描画する](https://ateraimemo.com/Swing/DnDLayerTabbedPane.html)

<!-- dummy comment line for breaking list -->

## コメント
- タブのドラッグ中、`JTable`上などで`Cursor`が点滅するのを修正。 -- *aterai* 2009-05-19 (火) 17:32:38
- 点滅の原因は？ -- *Dad* 2010-01-16 (土) 01:48:13
    - おそらく、[Cursor flickering during D&D when using CellRendererPane with validation](https://bugs.openjdk.java.net/browse/JDK-6700748)が原因。現在は、`canImport`メソッド内で、一々`GlassPane#setCursor(isDroppable ? DragSource.DefaultMoveDrop : DragSource.DefaultMoveNoDrop);`として回避中。 -- *aterai* 2010-01-16 (土) 12:25:38
- `6u20`ぐらいから`Web Start`で、`java.security.AccessControlException: access denied (java.awt.AWTPermission accessClipboard)`? -- *aterai* 2010-06-17 (木) 01:57:34
    - チュートリアルのデモ[Demo - DropDemo (The Java™ Tutorials > Creating a GUI With JFC/Swing Drag and Drop and Data Transfer)](https://docs.oracle.com/javase/tutorial/uiswing/dnd/dropmodedemo.html)でも同様のエラーが発生するので多分`Java 1.6.0_??`のバグ。 -- *aterai* 2010-06-17 (木) 14:31:14
    - `6u21`では、修正されている？: [6945178 2-High Defect SecurityException upon drag-and-drop(Bug/RFE fixed in JDK 6u21 build)](http://download.java.net/jdk6/6u21/promoted/b05/changes/JDK6u21.b05.list.html) -- *aterai* 2010-06-17 (木) 14:32:45
    - 修正されたようです。[Java SE 6 Update 21 Bug Fixes](http://www.oracle.com/technetwork/java/javase/bugfixes6u21-156339.html) -- *aterai* 2010-07-08 (木) 21:54:27
- `getTabPlacement()==RIGHT`などの場合に、`DropTarget`の描画がおかしくなるのを修正。 -- *aterai* 2012-02-05 (日) 11:13:40

<!-- dummy comment line for breaking list -->
