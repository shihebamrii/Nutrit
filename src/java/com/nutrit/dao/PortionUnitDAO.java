package com.nutrit.dao;

import com.nutrit.models.PortionUnit;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for portion/measurement units.
 * Refactored to use hardcoded data to strictly follow the 8-table schema.
 */
public class PortionUnitDAO {

    private static final List<PortionUnit> UNITS = new ArrayList<>();

    static {
        UNITS.add(createUnit(1, "Gramme", "g", 1.0));
        UNITS.add(createUnit(2, "Portion", "portion", 100.0));
        UNITS.add(createUnit(3, "Cuillère à soupe", "c.à.s", 15.0));
        UNITS.add(createUnit(4, "Cuillère à café", "c.à.c", 5.0));
        UNITS.add(createUnit(5, "Verre", "verre", 200.0));
        UNITS.add(createUnit(6, "Bol", "bol", 400.0));
        UNITS.add(createUnit(7, "Unité", "unité", 1.0));
    }

    private static PortionUnit createUnit(int id, String name, String abbr, Double grams) {
        PortionUnit unit = new PortionUnit();
        unit.setId(id);
        unit.setName(name);
        unit.setAbbreviation(abbr);
        unit.setGramsEquivalent(grams);
        return unit;
    }

    /**
     * Get all portion units
     */
    public List<PortionUnit> getAllPortionUnits() {
        return new ArrayList<>(UNITS);
    }

    /**
     * Get a single portion unit by ID
     */
    public PortionUnit getPortionUnitById(int id) {
        return UNITS.stream().filter(u -> u.getId() == id).findFirst().orElse(null);
    }

    /**
     * Get portion unit by abbreviation
     */
    public PortionUnit getPortionUnitByAbbreviation(String abbreviation) {
        if (abbreviation == null) return null;
        return UNITS.stream()
                .filter(u -> abbreviation.equalsIgnoreCase(u.getAbbreviation()))
                .findFirst()
                .orElse(null);
    }
}
