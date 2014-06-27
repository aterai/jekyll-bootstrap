---
layout: post
title: JTableのセルに複数のJButtonを配置する
category: swing
folder: MultipleButtonsInTableCell
tags: [JTable, TableCellEditor, TableCellRenderer, JButton, JPanel, ActionListener]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2009-10-05

## JTableのセルに複数のJButtonを配置する
`JTable`のセル内にクリック可能な複数の`JButton`を配置します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTQRygoYeI/AAAAAAAAAfU/-Sr9o7PsQkM/s800/MultipleButtonsInTableCell.png)

### サンプルコード
<pre class="prettyprint"><code>class ButtonsPanel extends JPanel {
  public final List&lt;JButton&gt; buttons =
    Arrays.asList(new JButton("view"), new JButton("edit"));
  public ButtonsPanel() {
    super();
    setOpaque(true);
    for(JButton b: buttons) {
      b.setFocusable(false);
      b.setRolloverEnabled(false);
      add(b);
    }
  }
}
</code></pre>
<pre class="prettyprint"><code>class ButtonsRenderer extends ButtonsPanel
                      implements TableCellRenderer {
  public ButtonsRenderer() {
    super();
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(JTable table,
        Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    setBackground(isSelected?table.getSelectionBackground():table.getBackground());
    return this;
  }
}
</code></pre>
<pre class="prettyprint"><code>class ButtonsEditor extends ButtonsPanel
                    implements TableCellEditor {
  public ButtonsEditor(final JTable table) {
    super();
    //----&gt;
    //DEBUG: view button click -&gt; control key down + edit button(same cell) press
    //       -&gt; remain selection color
    MouseListener ml = new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        ButtonModel m = ((JButton)e.getSource()).getModel();
        if(m.isPressed() &amp;&amp; table.isRowSelected(table.getEditingRow())
                         &amp;&amp; e.isControlDown()) {
          setBackground(table.getBackground());
        }
      }
    };
    buttons.get(0).addMouseListener(ml);
    buttons.get(1).addMouseListener(ml);
    //&lt;----

    buttons.get(0).addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        fireEditingStopped();
        JOptionPane.showMessageDialog(table, "Viewing");
      }
    });

    buttons.get(1).addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        int row = table.convertRowIndexToModel(table.getEditingRow());
        Object o = table.getModel().getValueAt(row, 0);
        fireEditingStopped();
        JOptionPane.showMessageDialog(table, "Editing: "+o);
      }
    });

    addMouseListener(new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        fireEditingStopped();
      }
    });
  }
  @Override public Component getTableCellEditorComponent(JTable table,
        Object value, boolean isSelected, int row, int column) {
    this.setBackground(table.getSelectionBackground());
    return this;
  }
  @Override public Object getCellEditorValue() {
    return "";
  }
  //Copied from AbstractCellEditor
  //protected EventListenerList listenerList = new EventListenerList();
  transient protected ChangeEvent changeEvent = null;
  @Override public boolean isCellEditable(java.util.EventObject e) {
    return true;
  }
//......
</code></pre>

### 解説
上記のサンプルでは、`CellRenderer`用と`CellEditor`用に、`JButton`を`2`つ配置した`JPanel`をそれぞれ作成しています。アクションイベントを設定するのは、`CellEditor`用の`JButton`で、`CellRenderer`用の`JButton`は表示のためのダミーです。

- - - -
- `LookAndFeel`などが更新されたら、`JTable#updateUI()`内で`SwingUtilities#updateRendererOrEditorUI()`を呼び出すなどして、各セルレンダラーやセルエディタ(これらは`JTable`の子コンポーネントではないので)を更新
    - `AbstractCellEditor`を継承するセルエディタは、`Component`も`DefaultCellEditor`も継承していないので、`LookAndFeel`を変更しても追従しない
    - そのため、`JTable#updateUI()`をオーバーライドして、セルエディタ自体を作成し直すなどの対応が必要
- このサンプルでは、`Component`を継承(`TableCellEditor`を実装)するセルエディタを作成し、`AbstractCellEditor`から必要なメソッドをコピーして回避する方法を使用している

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>//SwingUtilities#updateRendererOrEditorUI()
static void updateRendererOrEditorUI(Object rendererOrEditor) {
  if (rendererOrEditor == null) {
    return;
  }
  Component component = null;
  if (rendererOrEditor instanceof Component) {
    component = (Component)rendererOrEditor;
  }
  if (rendererOrEditor instanceof DefaultCellEditor) {
    component = ((DefaultCellEditor)rendererOrEditor).getComponent();
  }
  if (component != null) {
    SwingUtilities.updateComponentTreeUI(component);
  }
}
</code></pre>


- - - -
- `JSpinner`(`2`つの`JButton`と`JTextField`の組み合わせ)を`CellEditor`に使用する
    - [CellEditorをJSpinnerにして日付を変更](http://terai.xrea.jp/Swing/DateCellEditor.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.util.List;
import javax.swing.*;
import javax.swing.event.*;
import javax.swing.table.*;
import javax.swing.text.*;

public class ButtonsInsideCellTest {
  private JComponent makeUI() {
    String[] columnNames = {"Buttons", "Spinner"};
    Object[][] data = {
      {50, 100}, {100, 50}, {30, 20}, {0, 100}
    };
    DefaultTableModel model = new DefaultTableModel(data, columnNames) {
      @Override public Class&lt;?&gt; getColumnClass(int column) {
        return getValueAt(0, column).getClass();
      }
    };
    JTable table = new JTable(model);
    table.setRowHeight(36);
    table.setAutoCreateRowSorter(true);

    TableColumn column = table.getColumnModel().getColumn(0);
    column.setCellRenderer(new ButtonsRenderer());
    column.setCellEditor(new ButtonsEditor());

    column = table.getColumnModel().getColumn(1);
    column.setCellRenderer(new SpinnerRenderer());
    column.setCellEditor(new SpinnerEditor());

    return new JScrollPane(table);
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
    f.getContentPane().add(new ButtonsInsideCellTest().makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}

class SpinnerPanel extends JPanel {
  public final JSpinner spinner = new JSpinner(new SpinnerNumberModel(100, 0, 200, 1));
  public SpinnerPanel() {
    super(new GridBagLayout());
    GridBagConstraints c = new GridBagConstraints();

    c.weightx = 1.0;
    c.insets = new Insets(0, 10, 0, 10);
    c.fill = GridBagConstraints.HORIZONTAL;

    setOpaque(true);
    add(spinner, c);
  }
}
class SpinnerRenderer extends SpinnerPanel implements TableCellRenderer {
  public SpinnerRenderer() {
    super();
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    setBackground(isSelected?table.getSelectionBackground():table.getBackground());
    spinner.setValue((Integer)value);
    return this;
  }
}

class SpinnerEditor extends SpinnerPanel implements TableCellEditor {
//     public SpinnerEditor(final JTable table, final int column) {
//         super();
//     }
  @Override public Component getTableCellEditorComponent(
      JTable table, Object value, boolean isSelected, int row, int column) {
    this.setBackground(table.getSelectionBackground());
    spinner.setValue((Integer)value);
    return this;
  }
  @Override public Object getCellEditorValue() {
    //System.out.println("getCellEditorValue: " + spinner.getValue());
    //try {
    //  spinner.commitEdit();
    //} catch(Exception pe) {
    //  // Edited value is invalid, spinner.getValue() will return
    //  // the last valid value, you could revert the spinner to show that:
    //  JComponent editor = spinner.getEditor();
    //  if (editor instanceof JSpinner.DefaultEditor) {
    //    ((JSpinner.DefaultEditor)editor).getTextField().setValue(spinner.getValue());
    //  }
    //}
    return spinner.getValue();
  }

  //Copied from AbstractCellEditor
  //protected EventListenerList listenerList = new EventListenerList();
  transient protected ChangeEvent changeEvent = null;

  @Override public boolean isCellEditable(EventObject e) {
    return true;
  }
  @Override public boolean shouldSelectCell(EventObject anEvent) {
    return true;
  }
  @Override public boolean stopCellEditing() {
    try {
      spinner.commitEdit();
    } catch(Exception pe) {
      Toolkit.getDefaultToolkit().beep();
      return false;
      // 直前の値に戻して、編集を終了する場合
      // Edited value is invalid, spinner.getValue() will return
      // the last valid value, you could revert the spinner to show that:
      //JComponent editor = spinner.getEditor();
      //if (editor instanceof JSpinner.DefaultEditor) {
      //  ((JSpinner.DefaultEditor)editor).getTextField().setValue(spinner.getValue());
      //}
    }
    fireEditingStopped();
    return true;
  }
  @Override public void  cancelCellEditing() {
    fireEditingCanceled();
  }
  @Override public void addCellEditorListener(CellEditorListener l) {
    listenerList.add(CellEditorListener.class, l);
  }
  @Override public void removeCellEditorListener(CellEditorListener l) {
    listenerList.remove(CellEditorListener.class, l);
  }
  public CellEditorListener[] getCellEditorListeners() {
    return listenerList.getListeners(CellEditorListener.class);
  }
  protected void fireEditingStopped() {
    // Guaranteed to return a non-null array
    Object[] listeners = listenerList.getListenerList();
    // Process the listeners last to first, notifying
    // those that are interested in this event
    for(int i = listeners.length-2; i&gt;=0; i-=2) {
      if(listeners[i]==CellEditorListener.class) {
        // Lazily create the event:
        if(changeEvent == null) changeEvent = new ChangeEvent(this);
        ((CellEditorListener)listeners[i+1]).editingStopped(changeEvent);
      }
    }
  }
  protected void fireEditingCanceled() {
    // Guaranteed to return a non-null array
    Object[] listeners = listenerList.getListenerList();
    // Process the listeners last to first, notifying
    // those that are interested in this event
    for(int i = listeners.length-2; i&gt;=0; i-=2) {
      if(listeners[i]==CellEditorListener.class) {
        // Lazily create the event:
        if(changeEvent == null) changeEvent = new ChangeEvent(this);
        ((CellEditorListener)listeners[i+1]).editingCanceled(changeEvent);
      }
    }
  }
}

class ButtonsPanel extends JPanel {
  public final List&lt;JButton&gt; buttons = Arrays.asList(new JButton("+"), new JButton("-"));
  public final JLabel label = new JLabel() {
    @Override public Dimension getPreferredSize() {
      Dimension d = super.getPreferredSize();
      d.width = 50;
      return d;
    }
  };
  public int i = -1;
  public ButtonsPanel() {
    super();
    label.setHorizontalAlignment(SwingConstants.RIGHT);
    setOpaque(true);
    add(label);
    for(JButton b: buttons) {
      b.setFocusable(false);
      b.setRolloverEnabled(false);
      add(b);
    }
  }
}
class ButtonsRenderer extends ButtonsPanel implements TableCellRenderer {
  public ButtonsRenderer() {
    super();
    setName("Table.cellRenderer");
  }
  @Override public Component getTableCellRendererComponent(
      JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
    this.setBackground(isSelected?table.getSelectionBackground():table.getBackground());
    label.setText(value!=null?value.toString():"");
    return this;
  }
}
class ButtonsEditor extends ButtonsPanel implements TableCellEditor {
  public ButtonsEditor() {
    super();
    buttons.get(0).addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        i++;
        label.setText(""+i);
        fireEditingStopped();
      }
    });

    buttons.get(1).addActionListener(new ActionListener() {
      @Override public void actionPerformed(ActionEvent e) {
        i--;
        label.setText(""+i);
        fireEditingStopped();
      }
    });

    addMouseListener(new MouseAdapter() {
      @Override public void mousePressed(MouseEvent e) {
        fireEditingStopped();
      }
    });
  }
  @Override public Component getTableCellEditorComponent(
      JTable table, Object value, boolean isSelected, int row, int column) {
    this.setBackground(table.getSelectionBackground());
    i = (Integer)value;
    label.setText(""+i);
    return this;
  }
  @Override public Object getCellEditorValue() {
    return i;
  }

  //Copied from AbstractCellEditor
  //protected EventListenerList listenerList = new EventListenerList();
  transient protected ChangeEvent changeEvent = null;

  @Override public boolean isCellEditable(EventObject e) {
    return true;
  }
  @Override public boolean shouldSelectCell(EventObject anEvent) {
    return true;
  }
  @Override public boolean stopCellEditing() {
    fireEditingStopped();
    return true;
  }
  @Override public void  cancelCellEditing() {
    fireEditingCanceled();
  }
  @Override public void addCellEditorListener(CellEditorListener l) {
    listenerList.add(CellEditorListener.class, l);
  }
  @Override public void removeCellEditorListener(CellEditorListener l) {
    listenerList.remove(CellEditorListener.class, l);
  }
  public CellEditorListener[] getCellEditorListeners() {
    return listenerList.getListeners(CellEditorListener.class);
  }
  protected void fireEditingStopped() {
    // Guaranteed to return a non-null array
    Object[] listeners = listenerList.getListenerList();
    // Process the listeners last to first, notifying
    // those that are interested in this event
    for(int i = listeners.length-2; i&gt;=0; i-=2) {
      if(listeners[i]==CellEditorListener.class) {
        // Lazily create the event:
        if(changeEvent == null) changeEvent = new ChangeEvent(this);
        ((CellEditorListener)listeners[i+1]).editingStopped(changeEvent);
      }
    }
  }
  protected void fireEditingCanceled() {
    // Guaranteed to return a non-null array
    Object[] listeners = listenerList.getListenerList();
    // Process the listeners last to first, notifying
    // those that are interested in this event
    for(int i = listeners.length-2; i&gt;=0; i-=2) {
      if(listeners[i]==CellEditorListener.class) {
        // Lazily create the event:
        if(changeEvent == null) changeEvent = new ChangeEvent(this);
        ((CellEditorListener)listeners[i+1]).editingCanceled(changeEvent);
      }
    }
  }
}
</code></pre>

### 参考リンク
- [JTableのセルにJButtonを追加して行削除](http://terai.xrea.jp/Swing/DeleteButtonInCell.html)
- [JTableのセルにHyperlinkを表示](http://terai.xrea.jp/Swing/HyperlinkInTableCell.html)
- [Table Button Column « Java Tips Weblog](http://tips4java.wordpress.com/2009/07/12/table-button-column/)
- [JTableのセル中にJRadioButtonを配置](http://terai.xrea.jp/Swing/RadioButtonsInTableCell.html)
- [JTableのCellにJCheckBoxを複数配置する](http://terai.xrea.jp/Swing/CheckBoxesInTableCell.html)

<!-- dummy comment line for breaking list -->

### コメント
- 第`0`列目が編集状態でボタンをクリックした場合、パネルが二度表示されるバグを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-10-06 (火) 11:56:21
- [Table Button Column « Java Tips Weblog](http://tips4java.wordpress.com/2009/07/12/table-button-column/)を参考にして、`JTable#editCellAt`ではなく、逆に`TableCellEditor#stopCellEditing()`を使用してクリック直後に編集終了するように変更。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-11-03 (火) 04:36:55
- <kbd>Ctrl</kbd>キーを押しながら、`edit`ボタンをクリックすると異なる行(`table.getSelectedRow()`)の内容が表示されるバグを修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2011-03-10 (木) 02:35:35
- すごいと思いました！ -- [いわく](http://terai.xrea.jp/いわく.html) 2013-05-24 (金) 11:57:26
    - こんばんは。たしかに`JTable`の`TableCellRenderer`、`TableCellEditor`の仕組みは、すごい良くできているといつも感心してしまいます :) -- [aterai](http://terai.xrea.jp/aterai.html) 2013-05-24 (金) 23:59:16

<!-- dummy comment line for breaking list -->

