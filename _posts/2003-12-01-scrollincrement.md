---
layout: post
category: swing
folder: ScrollIncrement
title: JScrollPaneのスクロール量を変更
tags: [JScrollPane, JScrollBar]
author: aterai
pubdate: 2003-12-01
description: スクロールがホイールの回転でスムーズに移動しない(遅い)場合は、JScrollPaneのスクロール量を変更します。
image: https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTSi6qpTZI/AAAAAAAAAi8/nrtWKpDCdHI/s800/ScrollIncrement.png
comments: true
---
## 概要
スクロールがホイールの回転でスムーズに移動しない(遅い)場合は、`JScrollPane`のスクロール量を変更します。

{% download https://lh5.googleusercontent.com/_9Z4BYR88imo/TQTSi6qpTZI/AAAAAAAAAi8/nrtWKpDCdHI/s800/ScrollIncrement.png %}

## サンプルコード
<pre class="prettyprint"><code>JScrollPane scroll = new JScrollPane();
scroll.getVerticalScrollBar().setUnitIncrement(25);
</code></pre>

## 解説
`JScrollPane`からスクロールバーを取得し、`JScrollBar#setUnitIncrement(int)`メソッドでユニット増分値(`unitIncrement`)を設定しています。

- - - -
- `WindowsLookAndFeel`の場合、`JScrollBar#putClientProperty("JScrollBar.fastWheelScrolling", Boolean.TRUE);`を設定するとマウスホイールによるスクロールは高速化(デフォルトと同程度の速度)可能

<!-- dummy comment line for breaking list -->

- - - -
- `JScrollBar`の`UnitIncrement`と`BlockIncrement`について
    - [Mouse Wheel Controller « Java Tips Weblog](https://tips4java.wordpress.com/2010/01/10/mouse-wheel-controller/)
    - `Windows 7`環境での`e.getScrollAmount()`のデフォルト値: `3`
    - `DesktopProperty`などを経由せず、`OS`のコントロールパネルのマウスのプロパティを直接参照している模様？
- [How to Write a Mouse-Wheel Listener (The Java™ Tutorials > Creating a GUI With JFC/Swing > Writing Event Listeners)](https://docs.oracle.com/javase/tutorial/uiswing/events/mousewheellistener.html)
    - `scrollPane.getVerticalScrollBar().setBlockIncrement(...)`を設定した場合、その設定した値と`Scroll amount`(デフォルトの`3`固定) × `unit increment(scrollPane.getVerticalScrollBar().getUnitIncrement(...))`のより小さい方がホイールでのスクロール量となる
        - ただし、`scrollPane.getVerticalScrollBar().setBlockIncrement(...)`で設定した値が、`scrollPane.getVerticalScrollBar().getUnitIncrement(...)` より小さい場合は、`UnitIncrement`自体が、ホイールでのスクロール量となる
        - このため、例えば縦のアイテムを配置する通常の`JList`などのホイールスクロールをスクロールバーの矢印ボタンクリックと同じ`1`行ごとにしたいなら、`scrollPane.getVerticalScrollBar().setBlockIncrement(0)`でも可能
        - すでに上限、下限近くまでスクロールして余地がない場合などは除く(限界を超えてスクロールなどはしない)
    - ~~`Scrollable#getScrollableUnitIncrement(...)`などをオーバーライドしても、ホイールスクロールには関係ない？(カーソルキー用？)~~
    - `JScrollBar#getClientProperty("JScrollBar.fastWheelScrolling")`が`true`(デフォルト)で、`View`が`JList`などのように`Scrollable`を実装している場合は、`Scrollable#getScrollableUnitIncrement(...)`、`Scrollable#getScrollableBlockIncrement(...)`が使用されている
        - 詳細は`BasicScrollPaneUI.Handler`を参照
    - マウスのプロパティで「`1`画面ずつスクロールする」にすると、`e.getScrollType()`が`WHEEL_UNIT_SCROLL`から`WHEEL_BLOCK_SCROLL`になり、上記の`3`行×スクロール量(`BasicScrollBarUI.scrollByUnits(...)`)ではなく、`BasicScrollBarUI.scrollByBlock(...)`が使用される

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

public class WheelScrollTest {
  public JComponent makeUI() {
    JList list = makeList();
    final JScrollPane scrollPane = new JScrollPane(list) {
      @Override protected void processMouseWheelEvent(MouseWheelEvent e) {
        MouseWheelEvent mwe = new MouseWheelEvent(
          e.getComponent(),
          e.getID(),
          e.getWhen(),
          e.getModifiers(),
          e.getX(), e.getY(),
          e.getXOnScreen(),
          e.getYOnScreen(),
          e.getClickCount(),
          e.isPopupTrigger(),
          e.getScrollType(),
          100, //e.getScrollAmount(),
          e.getWheelRotation());
        System.out.println("ScrollAmount: " + e.getScrollAmount());
        super.processMouseWheelEvent(mwe);
      }
    };

    scrollPane.addMouseWheelListener(new MouseWheelListener() {
      @Override public void mouseWheelMoved(MouseWheelEvent e) {
        if (e.getScrollType() == MouseWheelEvent.WHEEL_UNIT_SCROLL) {
          System.out.println("WHEEL_UNIT_SCROLL");
        } else if (e.getScrollType() == MouseWheelEvent.WHEEL_BLOCK_SCROLL) {
          System.out.println("WHEEL_BLOCK_SCROLL");
        }
      }
    });

    list.setFixedCellHeight(64);
    scrollPane.getVerticalScrollBar().setUnitIncrement(32);
    scrollPane.getVerticalScrollBar().setBlockIncrement(64 * 6);

    JViewport vp = scrollPane.getViewport();
    Scrollable view = (Scrollable) vp.getView();
    Rectangle vr = vp.getViewRect();

    System.out.println(
        "FixedCellHeight: " + list.getFixedCellHeight());
    System.out.println(
        "getUnitIncrement: " + scrollPane.getVerticalScrollBar().getUnitIncrement(1));
    System.out.println(
        "getBlockIncrement: " + scrollPane.getVerticalScrollBar().getBlockIncrement(1));
    System.out.println(
        "getScrollableUnitIncrement: " + view.getScrollableUnitIncrement(
        vr, scrollPane.getVerticalScrollBar().getOrientation(), 1));
    System.out.println("getScrollableBlockIncrement: " + view.getScrollableBlockIncrement(
        vr, scrollPane.getVerticalScrollBar().getOrientation(), 1));

    scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
    final JSpinner spinner = new JSpinner(new SpinnerNumberModel(
        scrollPane.getVerticalScrollBar().getBlockIncrement(1), 0, 100000, 1));
    spinner.setEditor(new JSpinner.NumberEditor(spinner, "#####0"));
    spinner.addChangeListener(new ChangeListener() {
      @Override public void stateChanged(ChangeEvent e) {
        JSpinner s = (JSpinner) e.getSource();
        Integer iv = (Integer) s.getValue();
        //System.out.println(iv);
        scrollPane.getVerticalScrollBar().setBlockIncrement(iv);
      }
    });
    Box box = Box.createHorizontalBox();
    box.add(new JLabel("Block Increment:"));
    box.add(Box.createHorizontalStrut(2));
    box.add(spinner);
    box.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));

    JPanel p = new JPanel(new BorderLayout());
    p.add(box, BorderLayout.NORTH);
    p.add(scrollPane);
    return p;
  }
  @SuppressWarnings("unchecked")
  private static JList makeList() {
    DefaultListModel model = new DefaultListModel();
    for (int i = 0; i &lt; 100; i++) {
      model.addElement("Item: " + i);
    }
    JList list = new JList(model) {
//       @Override public int getScrollableUnitIncrement(
//           Rectangle visibleRect, int orientation, int direction) {
//         return 64;
//       }
//       @Override public int getScrollableBlockIncrement(
//           Rectangle visibleRect, int orientation, int direction) {
//         if (orientation == SwingConstants.VERTICAL) {
//           int inc = visibleRect.height;
//           /* Scroll Down */
//           if (direction &gt; 0) {
//             // last cell is the lowest left cell
//             int last = locationToIndex(
//               new Point(visibleRect.x, visibleRect.y + visibleRect.height - 1));
//             if (last != -1) {
//               Rectangle lastRect = getCellBounds(last, last);
//               if (lastRect != null) {
//                 inc = lastRect.y - visibleRect.y;
//                 if ((inc == 0) &amp;&amp; (last &lt; getModel().getSize() - 1)) {
//                   inc = lastRect.height;
//                 }
//               }
//             }
//           }
//           /* Scroll Up */
//           else {
//             int newFirst = locationToIndex(
//               new Point(visibleRect.x, visibleRect.y - visibleRect.height));
//             int first = getFirstVisibleIndex();
//             if (newFirst != -1) {
//               if (first == -1) {
//                 first = locationToIndex(visibleRect.getLocation());
//               }
//               Rectangle newFirstRect = getCellBounds(newFirst, newFirst);
//               Rectangle firstRect = getCellBounds(first, first);
//               if ((newFirstRect != null) &amp;&amp; (firstRect != null)) {
//                 while ( (newFirstRect.y + visibleRect.height &lt;
//                      firstRect.y + firstRect.height) &amp;&amp;
//                     (newFirstRect.y &lt; firstRect.y) ) {
//                   newFirst++;
//                   newFirstRect = getCellBounds(newFirst, newFirst);
//                 }
//                 inc = visibleRect.y - newFirstRect.y;
//                 if ((inc &lt;= 0) &amp;&amp; (newFirstRect.y &gt; 0)) {
//                   newFirst--;
//                   newFirstRect = getCellBounds(newFirst, newFirst);
//                   if (newFirstRect != null) {
//                     inc = visibleRect.y - newFirstRect.y;
//                   }
//                 }
//               }
//             }
//           }
//           return 128;
//         }
//         return super.getScrollableBlockIncrement(visibleRect, orientation, direction);
//       }
    };
    list.setCellRenderer(new DefaultListCellRenderer() {
      private final Color ec = new Color(240, 240, 240);
      @Override public Component getListCellRendererComponent(
        JList list, Object value, int index, boolean isSelected, boolean cellHasFocus) {
        super.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);
        if (isSelected) {
          setForeground(list.getSelectionForeground());
          setBackground(list.getSelectionBackground());
        } else {
          setForeground(list.getForeground());
          setBackground(((index % 2 == 0)) ? ec : list.getBackground());
        }
        return this;
      }
    });
    return list;
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(new WheelScrollTest().makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}
</code></pre>

## 参考リンク
- [JScrollBar#setUnitIncrement(int) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JScrollBar.html#setUnitIncrement-int-)
- [Mouse Wheel Controller « Java Tips Weblog](https://tips4java.wordpress.com/2010/01/10/mouse-wheel-controller/)
- [How to Write a Mouse-Wheel Listener (The Java™ Tutorials > Creating a GUI With JFC/Swing > Writing Event Listeners)](https://docs.oracle.com/javase/tutorial/uiswing/events/mousewheellistener.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JScrollBar`の`UnitIncrement`と`BlockIncrement`についてのメモを追加。 -- *aterai* 2012-07-10 (火) 21:03:39

<!-- dummy comment line for breaking list -->
