---
layout: post
category: swing
folder: ColorComboBox
title: JComboBoxの色を変更
tags: [JComboBox, ListCellRenderer, JTextField]
author: aterai
pubdate: 2005-01-10T01:48:08+09:00
description: JComboBoxのEditor部分と、List部分の色を変更します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJhY0CAaI/AAAAAAAAAUg/J70FCr-EUlI/s800/ColorComboBox.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2009/06/color-jcombobox.html
    lang: en
comments: true
---
## 概要
`JComboBox`の`Editor`部分と、`List`部分の色を変更します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTJhY0CAaI/AAAAAAAAAUg/J70FCr-EUlI/s800/ColorComboBox.png %}

## サンプルコード
<pre class="prettyprint"><code>class AlternateRowColorComboBox&lt;E&gt; extends JComboBox&lt;E&gt; {
  private static final Color EVEN_BGCOLOR = new Color(225, 255, 225);
  private static final Color ODD_BGCOLOR  = new Color(255, 255, 255);
  private transient ItemListener itemColorListener;

  public AlternateRowColorComboBox() {
    super();
  }
  public AlternateRowColorComboBox(ComboBoxModel&lt;E&gt; aModel) {
    super(aModel);
  }
  public AlternateRowColorComboBox(E[] items) {
    super(items);
  }
  @Override public void setEditable(boolean aFlag) {
    super.setEditable(aFlag);
    if (aFlag) {
      JTextField field = (JTextField) getEditor().getEditorComponent();
      field.setOpaque(true);
      field.setBackground(getAlternateRowColor(getSelectedIndex()));
    }
  }
  @Override public void updateUI() {
    removeItemListener(itemColorListener);
    super.updateUI();
    setRenderer(new DefaultListCellRenderer() {
      @Override public Component getListCellRendererComponent(
          JList list, Object value, int index, boolean isSelected, boolean cellHasFocus) {
        JLabel c = (JLabel) super.getListCellRendererComponent(
            list, value, index, isSelected, cellHasFocus);
        c.setOpaque(true);
        if (!isSelected) {
          c.setBackground(getAlternateRowColor(index));
        }
        return c;
      }
    });
    if (itemColorListener == null) {
      itemColorListener = new ItemListener() {
        @Override public void itemStateChanged(ItemEvent e) {
          if (e.getStateChange() != ItemEvent.SELECTED) {
            return;
          }
          JComboBox cb = (JComboBox) e.getItemSelectable();
          Color rc = getAlternateRowColor(cb.getSelectedIndex());
          if (cb.isEditable()) {
            JTextField field = (JTextField) cb.getEditor().getEditorComponent();
            field.setBackground(rc);
          } else {
            cb.setBackground(rc);
          }
        }
      };
    }
    addItemListener(itemColorListener);
    JTextField field = (JTextField) getEditor().getEditorComponent();
    if (field != null) {
      field.setOpaque(true);
      field.setBackground(getAlternateRowColor(getSelectedIndex()));
    }
  }
  private static Color getAlternateRowColor(int index) {
    return (index % 2 == 0) ? EVEN_BGCOLOR : ODD_BGCOLOR;
  }
}
</code></pre>

## 解説
上記のサンプルでは、`JComboBox`を編集可にした状態で、以下のように`List`部分、`Editor`部分に行の奇数偶数で背景色を変更しています。

- `List`部分
    - `ListCellRenderer`を使用することで背景色を変更
- `Editor`部分
    - `getEditor().getEditorComponent()`で`JTextField`オブジェクトを取得して背景色を変更

<!-- dummy comment line for breaking list -->

- - - -
- `GTKLookAndFeel`などで`Box`(`Editor`)部分の色を変更できない場合がある

<!-- dummy comment line for breaking list -->

![screenshot](https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJj4vDxSI/AAAAAAAAAUk/ZZtKylfc0k8/s800/ColorComboBox1.png)

## 参考リンク
- [JComboBoxの文字色を変更する](https://ateraimemo.com/Swing/ComboBoxForegroundColor.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JComboBox#setEditable(true)`は必須のようです。編集不可にするには`Editor`部分の`JTextField`に対して`setEditable(false)` -- *Y* 2006-10-10 (火) 18:51:38
    - ご指摘ありがとうございます。せっかく`JComboBox`を上下に並べているので、編集可の場合と不可の場合のサンプルにすればよかったですね。編集不可の場合(`JComboBox#setEditable(false)`)に色を着けるには、上記の方法と、以下のように`JComboBox#setBackground(Color)`メソッドを使う方法があるようです。 ~~編集不可の場合は、この部分の色もレンダラーが勝手にやってくれてたような気がするのですが、勘違いだったのかも。~~ バージョンや`LookAndFeel`で異なる？ようです。 -- *aterai* 2006-10-10 (火) 19:58:51

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>final JComboBox c = new JComboBox();
c.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if (e.getStateChange() != ItemEvent.SELECTED) {
      return;
    }
    c.setBackground((c.getSelectedIndex() % 2 == 0) ? evenBGColor : oddBGColor);
  }
});
</code></pre>

    - せっかくなので、上の`JComboBox`は編集不可、下は編集可の場合で、色を着けるサンプルに変更しました。 -- *aterai* 2006-10-10 (火) 20:31:03
- メモ: [Windows/Motif L&F: Changing the JComboBox background does not change the popup of the JCombobox](https://bugs.openjdk.java.net/browse/JDK-6367601) -- *aterai* 2007-12-13 (木) 15:43:50
- サンプルソースの`LookAndFeel`を設定しないようにすると、編集不可コンボはボタン部分も背景色になってしまう・・ -- *han* 2008-10-21 (火) 10:41:38
    - `MetalLookAndFeel`などは、コンボボックスの背景色を変更すると矢印ボタンの色まで変更してしまう仕様？みたいですね。回避するなら、以下のように`UI`で使っている`PropertyChangeListener`をオーバーライドしてしまうのはどうでしょう。 -- *aterai* 2008-10-21 (火) 15:41:21

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>combo01.setUI(new MetalComboBoxUI() {
  @Override public PropertyChangeListener createPropertyChangeListener() {
    return new MetalPropertyChangeListener() {
      @Override public void propertyChange(PropertyChangeEvent e) {
        String propertyName = e.getPropertyName();
        if (propertyName == "background") {
          Color color = (Color) e.getNewValue();
          //arrowButton.setBackground(color);
          listBox.setBackground(color);
        } else {
          super.propertyChange( e );
        }
      }
    };
  }
});
combo01.setModel(makeModel());
combo01.setRenderer(new MyListCellRenderer(combo01.getRenderer()));
combo01.addItemListener(new ItemListener() {
  @Override public void itemStateChanged(ItemEvent e) {
    if (e.getStateChange() != ItemEvent.SELECTED) {
      return;
    }
    combo01.setBackground(getOEColor(combo01.getSelectedIndex()));
  }
});
combo01.setSelectedIndex(0);
combo01.setBackground(evenBGColor);
</code></pre>

- ありがとうございます。動作確認してませんが`UI`をさわればいろんなことができそうですね。で`UIManager`でなんとかできないか気になったので試すと、`UIManager.put("ComboBox.background", new ColorUIResource(Color.white));`で全てのコンボボックスの背景色を設定できました（リストの色分けはできないですが） -- *han* 2008-10-24 (金) 11:28:10

<!-- dummy comment line for breaking list -->
